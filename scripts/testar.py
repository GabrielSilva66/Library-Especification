#!/usr/bin/env python3
"""Executa a suite CafeOBJ e rejeita erros, assercoes falsas ou testes ausentes."""
import argparse
from pathlib import Path
import re
import shutil
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--homebrew", action="store_true",
                        help="inicializa o prelude e as bibliotecas da instalacao Homebrew")
    parser.add_argument("--verbose", action="store_true", help="mostra toda a saida do CafeOBJ")
    args = parser.parse_args()
    executable = shutil.which("cafeobj") or shutil.which("CafeOBJ")
    if not executable:
        parser.error("CafeOBJ nao encontrado no PATH.")

    spec = Path(__file__).resolve().parents[1] / "spec"
    suite = spec / "testes.cafe"
    files = re.findall(r"^in\s+(\S+)\s*$", suite.read_text(encoding="utf-8"), re.MULTILINE)
    expected = sum(len(re.findall(r"^\s*red\s+", (spec / name).read_text(encoding="utf-8"), re.MULTILINE))
                   for name in files)
    command = [executable, "-batch", suite.name]
    cwd = spec
    stdin = ""

    if args.homebrew:
        # Resolve o symlink para nao fixar a versao nem /opt/homebrew no script.
        prefix = Path(executable).resolve().parent.parent
        preludes = sorted(prefix.glob("share/cafeobj-*/prelude/std.bin"))
        if len(preludes) != 1:
            parser.error(f"Nao foi encontrado um prelude unico sob {prefix}/share.")
        prelude = preludes[0]
        lib = prelude.parent.parent / "lib"
        if not lib.is_dir():
            parser.error(f"Bibliotecas nao encontradas: {lib}")
        # O diretorio inicial permite encontrar std.bin; select dispara o
        # autoload das bibliotecas sem redefini-las. Nenhuma instalacao e editada.
        cwd = prelude.parent
        command = [executable]
        stdin = (f"cd {lib}\nselect BOOL .\nselect NAT .\nselect STRING .\n"
                 f"cd {spec}\nin {suite.name}\nquit\n")

    try:
        result = subprocess.run(command, cwd=cwd, input=stdin, text=True, encoding="utf-8",
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                timeout=60)
    except (OSError, subprocess.TimeoutExpired) as error:
        print(f"FALHA: nao foi possivel concluir os testes: {error}", file=sys.stderr)
        return 1

    output = result.stdout
    reductions = len(re.findall(r"^-- reduce in ", output, re.MULTILINE))
    passed = len(re.findall(r"^\(true\):Bool\s*$", output, re.MULTILINE))
    diagnostics = re.search(r"\[(?:Error|Warning)\]|Caught an exception", output, re.IGNORECASE)
    ok = expected > 0 and result.returncode == 0 and not diagnostics and reductions == passed == expected
    if args.verbose or not ok:
        print(output)
    print(f"{'OK' if ok else 'FALHA'}: {passed}/{expected} assercoes verdadeiras; "
          f"{reductions} reducoes executadas.")
    if not ok and not args.homebrew and reductions == 0:
        print("Em instalacoes Homebrew/CLISP, tente: python3 scripts/testar.py --homebrew")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
