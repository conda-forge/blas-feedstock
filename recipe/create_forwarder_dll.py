import os
import subprocess

def run(arg):
  return subprocess.check_output(arg, shell=True).decode("utf-8")

NEW_ENV = os.environ["NEW_ENV"]
REF_DLL_DIR = os.path.join(NEW_ENV, "Library", "bin")
PREFIX = os.environ["PREFIX"]
IMPL_LIB_DIR = os.path.join(PREFIX, "Library", "lib")
target_platform = os.environ["target_platform"]

if target_platform == "win-64":
  machine = "x64"
else:
  raise NotImplementedError(f"Unknown platform: {machine}")

open("empty.c", "a").close()
blas_impl_lib = os.environ["blas_impl_lib"]
run("cl.exe /c empty.c")

for name in ["libblas", "libcblas", "liblapack", "liblapacke"]:
  dump = run(f"dumpbin /EXPORTS {REF_DLL_DIR}\\{name}.dll")
  started = False
  symbols = []
  for line in dump.split("\n"):
    if line.strip().startswith("ordinal"):
      started = True
    if line.strip().startswith("Summary"):
      break 
    if started and line.strip() != "":
      symbol = line.strip().split(" ")[-1]
      if symbol.startswith(("c", "s", "L", "d", "z", "i", "l", "x", "C", "R")):
        symbols.append(symbol)
      else:
        print(f"ignoring: {symbol}")
  print(symbols)
  
  with open(f"{name}_impl.def", "w") as f:
    f.write(f"LIBRARY {blas_impl_lib}\n")
    f.write("EXPORTS\n")
    for symbol in symbols:
      f.write(f"  {symbol}\n")
      
  run(f"lib /def:{name}_impl.def /out:{name}_impl.lib /MACHINE:{machine}")

  with open(f"{name}.def", "w") as f:
    f.write(f"LIBRARY {name}.dll\n")
    f.write("EXPORTS\n")
    for symbol in symbols:
      f.write(f"  {symbol} = {blas_impl_lib}.{symbol}\n")
  run(f"link.exe /DLL /OUT:{name}.dll /DEF:{name}.def /MACHINE:{machine} empty.obj {name}_impl.lib")
