#!/usr/bin/env python3
"""Executa os proof scores em proofs/ e exibe um resumo limpo das reduções."""
import argparse
from pathlib import Path
import re
import shutil
import subprocess
import sys


RE_REDUCE_START = re.compile(r"^-- reduce in [^:]+:\s*(.+?)\s*$")
RE_TIMING = re.compile(r"^\(\d+\.\d+\s+sec\s+for\s+parse,")
RE_DIAGNOSTIC = re.compile(r"\[(?:Error|Warning)\]|Caught an exception", re.IGNORECASE)


def extract_reductions(output: str) -> list[tuple[str, str]]:
    """Extrai pares (expressão, resultado_final) da saída do CafeOBJ."""
    results: list[tuple[str, str]] = []
    current_expr: str | None = None
    last_value: str | None = None

    for raw_line in output.splitlines():
        line = raw_line.strip()
        match = RE_REDUCE_START.match(line)
        if match:
            if current_expr is not None:
                results.append((current_expr, last_value or "<sem resultado>"))
            current_expr = match.group(1)
            last_value = None
            continue

        if current_expr is None:
            continue

        if RE_TIMING.match(line):
            results.append((current_expr, last_value or "<sem resultado>"))
            current_expr = None
            last_value = None
            continue

        # Ignora linhas de trace e metadados para capturar apenas a linha de resultado.
        if (
            line
            and not line.startswith(("1>", "1<", "{", "}", "-- "))
            and not line.startswith("[Leaving CafeOBJ]")
        ):
            last_value = line

    if current_expr is not None:
        results.append((current_expr, last_value or "<sem resultado>"))

    return results


def run_proof_file(executable: str, root: Path, proof_file: Path, verbose: bool) -> bool:
    expected = len(
        re.findall(r"^\s*red\s+", proof_file.read_text(encoding="utf-8"), re.MULTILINE)
    )
    rel_path = proof_file.relative_to(root)

    try:
        result = subprocess.run(
            [executable, "-batch", str(rel_path)],
            cwd=root,
            text=True,
            encoding="utf-8",
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=60,
        )
    except (OSError, subprocess.TimeoutExpired) as error:
        print(f"FALHA [{rel_path}]: erro ao executar: {error}", file=sys.stderr)
        return False

    output = result.stdout
    if verbose:
        print(output)

    reductions = extract_reductions(output)
    diagnostics = RE_DIAGNOSTIC.findall(output)
    passed = sum(1 for _, val in reductions if val == "(true):Bool")
    ok = (
        expected > 0
        and result.returncode == 0
        and not diagnostics
        and len(reductions) == expected
        and passed == expected
    )

    status = "OK" if ok else "FALHA"
    print(f"=== {rel_path} [{status}: {passed}/{expected}] ===")
    for idx, (expr, val) in enumerate(reductions, start=1):
        tag = "PASS" if val == "(true):Bool" else "FAIL"
        print(f"  [{tag}] #{idx}: {expr} => {val}")

    if diagnostics:
        print(f"  [AVISO] Diagnósticos encontrados: {len(diagnostics)}")
    if len(reductions) != expected:
        print(f"  [AVISO] Esperadas {expected} reduções, executadas {len(reductions)}.")

    return ok


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "files",
        nargs="*",
        help="arquivos .cafe específicos (padrão: todos os .cafe em proofs/)",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="exibe a saída completa do CafeOBJ (incluindo trace)",
    )
    args = parser.parse_args()

    executable = shutil.which("cafeobj") or shutil.which("CafeOBJ")
    if not executable:
        parser.error("CafeOBJ nao encontrado no PATH.")

    root = Path(__file__).resolve().parents[1]
    proofs_dir = root / "proofs"

    if args.files:
        targets = [Path(f).resolve() for f in args.files]
    else:
        targets = sorted(proofs_dir.glob("*.cafe"))

    if not targets:
        print("Nenhum arquivo .cafe encontrado em proofs/.", file=sys.stderr)
        return 1

    all_ok = True
    for target in targets:
        if not run_proof_file(executable, root, target, args.verbose):
            all_ok = False

    return 0 if all_ok else 1


if __name__ == "__main__":
    sys.exit(main())
