#!/usr/bin/env -S nim e --hints:off

import std/[os, sequtils, strformat, strutils, tables]

# Ce script permet de générer les fichiers D pour le package core.
# Il génère également les fichiers package.d, afin de pouvoir importer
# directement plusieurs fichiers en écrivant "import mss.core.component;"
# par exemple.

const
  corePackage = "source" / "mss" / "core"
  allFilenames = {
    "component": @["component", "component_factory", "input_manager", "memory",
        "output_controller", "processing_unit"],
    "computer": @["computer", "computer_model"],
    "error": @["duplicate_name", "internal_run", "invalid_configuration",
        "invalid_matrix", "invalid_plan", "invalid_weight", "matrix_not_found",
        "mss", "overflow", "unreadable_file"].mapIt(it & "_exception") & @[
        "error_code"],
    "matrix": @["acquisition_mode", "block", "block_cell", "block_pair",
        "block_position", "input_matrix", "matrix", "matrix_rules",
        "matrix_size"],
    "trace": @["execution_log", "log_entry", "sub_total", "trace_step"],
    "weight": @["action", "component_category", "component_model",
        "weight_table"],
  }.toTable
  enumFilenames = ["acquisition_mode", "matrix_size", "block_cell", "action", "error_code"]

func toPascalCase(name: string): string =
  result = newStringOfCap(name.len)
  result.add(name[0].toUpperAscii())
  var i = 1
  while i < name.len:
    if name[i] == '_':
      inc(i)
      result.add(name[i].toUpperAscii())
    else:
      result.add(name[i])
    inc(i)

doAssert "hello_world".toPascalCase() == "HelloWorld"

rmDir(corePackage)
mkDir(corePackage)

for package, filenames in allFilenames:
  mkDir(corePackage / package)

  var packageFileContent = &"module mss.core.{package};\n\n"
  for filename in filenames:
    var content = &"module mss.core.{package}.{filename};\n\n"

    # Ce package contient toutes les interfaces
    if package == "component":
      content.add("interface ")
    elif filename in enumFilenames:
      content.add("enum ")
    else:
      content.add("class ")
    content.add(filename.toPascalCase())
    content.add("\n{\n}\n")
    writeFile(corePackage / package / (filename & ".d"), content)
    packageFileContent.add(&"public import mss.core.{package}.{filename};\n")

  writeFile(corePackage / package / "package.d", packageFileContent)
