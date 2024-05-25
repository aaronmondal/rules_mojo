---
title: //mojo:defs.bzl
description: The Bazel rules for Mojo.
---

Import these rules in your `BUILD.bazel` files.

To load for example the `mojo_binary` rule:

```python
load("@rules_mojo//mojo:defs.bzl", "mojo_binary")
```

<a id="mojo_binary"></a>

## `mojo_binary`

<pre><code>mojo_binary(<a href="#mojo_binary-name">name</a>, <a href="#mojo_binary-deps">deps</a>, <a href="#mojo_binary-srcs">srcs</a>, <a href="#mojo_binary-compile_flags">compile_flags</a>, <a href="#mojo_binary-compile_string_flags">compile_string_flags</a>, <a href="#mojo_binary-defines">defines</a>, <a href="#mojo_binary-includes">includes</a>, <a href="#mojo_binary-runtime_data">runtime_data</a>)</code></pre>
Creates an executable.

Example:

  ```python
  mojo_binary(
      name = "hello",
      srcs = ["hello.mojo"],
  )
  ```
### Attributes

| Name  | Description |
| :---- | :---------- |
| <a id="mojo_binary-name"></a>`name` | <code><a href="https://bazel.build/concepts/labels#target-names">Name</a></code>, required.<br><br> A unique name for this target.   |
| <a id="mojo_binary-deps"></a>`deps` | <code><a href="https://bazel.build/concepts/labels">List of labels</a></code>, optional, defaults to <code>[]</code>.<br><br> The dependencies for this target.<br><br>Use `ll_library` targets here. Other targets won't work.   |
| <a id="mojo_binary-srcs"></a>`srcs` | <code><a href="https://bazel.build/concepts/labels">List of labels</a></code>, optional, defaults to <code>[]</code>.<br><br> Compilable source files for this target.<br><br>Allowed file extensions: `[".mojo", ".ð¥"]`.<br><br>Place headers in the `hdrs` attribute.   |
| <a id="mojo_binary-compile_flags"></a>`compile_flags` | <code>List of strings</code>, optional, defaults to <code>[]</code>.<br><br> Flags for the compiler.<br><br>Pass a list of strings here. For instance `["-O3", "-std=c++20"]`.<br><br>Split flag pairs `-Xclang -somearg` into separate flags `["-Xclang", "-somearg"]`.<br><br>Unavailable to downstream targets.   |
| <a id="mojo_binary-compile_string_flags"></a>`compile_string_flags` | <code><a href="https://bazel.build/concepts/labels">List of labels</a></code>, optional, defaults to <code>[]</code>.<br><br> Flags for the compiler in the form of `string_flag`s.<br><br>Splits the values of each `string_flag` along colons like so:<br><br><pre><code class="language-python">load("@bazel_skylib//rules:common_settings.bzl", "string_flag")&#10;&#10;string_flag(&#10;    name = "myflags",&#10;    build_setting_default = "a:b:c",&#10;)&#10;&#10;mojo_library(&#10;    # ...&#10;    # Equivalent to `compile_flags = ["a", "b", "c"]`&#10;    compile_string_flags = [":myflags"],&#10;)</code></pre><br><br>Useful for externally configurable build attributes, such as generated flags from Nix environments.   |
| <a id="mojo_binary-defines"></a>`defines` | <code>List of strings</code>, optional, defaults to <code>[]</code>.<br><br> Defines for this target.<br><br>Pass a list of strings here. For instance `["MYDEFINE_1", "MYDEFINE_2"]`.<br><br>Unavailable to downstream targets.   |
| <a id="mojo_binary-includes"></a>`includes` | <code>List of strings</code>, optional, defaults to <code>[]</code>.<br><br> Include paths, relative to the target workspace.<br><br>Uses `-iquote`.<br><br>Useful if you need custom include prefix stripping for dynamic paths, for instance the ones generated by `bzlmod`. Instead of `compile_flags = ["-iquoteexternal/mydep.someversion/include"]`, use `includes = ["include"]` to add the path to the workspace automatically.<br><br>Expands paths starting with `$(GENERATED)` to the workspace location in the `GENDIR` path.<br><br>Unavailable to downstream targets.   |
| <a id="mojo_binary-runtime_data"></a>`runtime_data` | <code><a href="https://bazel.build/concepts/labels">List of labels</a></code>, optional, defaults to <code>[]</code>.<br><br> Extra files made available during test time.   |


<a id="mojo_library"></a>

## `mojo_library`

<pre><code>mojo_library(<a href="#mojo_library-name">name</a>, <a href="#mojo_library-deps">deps</a>, <a href="#mojo_library-srcs">srcs</a>, <a href="#mojo_library-compile_flags">compile_flags</a>, <a href="#mojo_library-compile_string_flags">compile_string_flags</a>, <a href="#mojo_library-defines">defines</a>, <a href="#mojo_library-includes">includes</a>)</code></pre>
Creates a Mojo package.

Example:

  ```python
  mojo_library(
      name = "mypackage",
      srcs = [
          "__init__.mojo",
          "my_package.mojo",
      ],
  )
  ```
### Attributes

| Name  | Description |
| :---- | :---------- |
| <a id="mojo_library-name"></a>`name` | <code><a href="https://bazel.build/concepts/labels#target-names">Name</a></code>, required.<br><br> A unique name for this target.   |
| <a id="mojo_library-deps"></a>`deps` | <code><a href="https://bazel.build/concepts/labels">List of labels</a></code>, optional, defaults to <code>[]</code>.<br><br> The dependencies for this target.<br><br>Use `ll_library` targets here. Other targets won't work.   |
| <a id="mojo_library-srcs"></a>`srcs` | <code><a href="https://bazel.build/concepts/labels">List of labels</a></code>, optional, defaults to <code>[]</code>.<br><br> Compilable source files for this target.<br><br>Allowed file extensions: `[".mojo", ".ð¥"]`.<br><br>Place headers in the `hdrs` attribute.   |
| <a id="mojo_library-compile_flags"></a>`compile_flags` | <code>List of strings</code>, optional, defaults to <code>[]</code>.<br><br> Flags for the compiler.<br><br>Pass a list of strings here. For instance `["-O3", "-std=c++20"]`.<br><br>Split flag pairs `-Xclang -somearg` into separate flags `["-Xclang", "-somearg"]`.<br><br>Unavailable to downstream targets.   |
| <a id="mojo_library-compile_string_flags"></a>`compile_string_flags` | <code><a href="https://bazel.build/concepts/labels">List of labels</a></code>, optional, defaults to <code>[]</code>.<br><br> Flags for the compiler in the form of `string_flag`s.<br><br>Splits the values of each `string_flag` along colons like so:<br><br><pre><code class="language-python">load("@bazel_skylib//rules:common_settings.bzl", "string_flag")&#10;&#10;string_flag(&#10;    name = "myflags",&#10;    build_setting_default = "a:b:c",&#10;)&#10;&#10;mojo_library(&#10;    # ...&#10;    # Equivalent to `compile_flags = ["a", "b", "c"]`&#10;    compile_string_flags = [":myflags"],&#10;)</code></pre><br><br>Useful for externally configurable build attributes, such as generated flags from Nix environments.   |
| <a id="mojo_library-defines"></a>`defines` | <code>List of strings</code>, optional, defaults to <code>[]</code>.<br><br> Defines for this target.<br><br>Pass a list of strings here. For instance `["MYDEFINE_1", "MYDEFINE_2"]`.<br><br>Unavailable to downstream targets.   |
| <a id="mojo_library-includes"></a>`includes` | <code>List of strings</code>, optional, defaults to <code>[]</code>.<br><br> Include paths, relative to the target workspace.<br><br>Uses `-iquote`.<br><br>Useful if you need custom include prefix stripping for dynamic paths, for instance the ones generated by `bzlmod`. Instead of `compile_flags = ["-iquoteexternal/mydep.someversion/include"]`, use `includes = ["include"]` to add the path to the workspace automatically.<br><br>Expands paths starting with `$(GENERATED)` to the workspace location in the `GENDIR` path.<br><br>Unavailable to downstream targets.   |


<a id="mojo_test"></a>

## `mojo_test`

<pre><code>mojo_test(<a href="#mojo_test-name">name</a>, <a href="#mojo_test-deps">deps</a>, <a href="#mojo_test-srcs">srcs</a>, <a href="#mojo_test-compile_flags">compile_flags</a>, <a href="#mojo_test-compile_string_flags">compile_string_flags</a>, <a href="#mojo_test-defines">defines</a>, <a href="#mojo_test-includes">includes</a>, <a href="#mojo_test-runtime_data">runtime_data</a>)</code></pre>
Testable wrapper around `mojo_binary`.

Consider using this rule over Skylib's `native_test` targets to propagate shared
libraries to the test invocations.

Example:

  ```python
  mojo_test(
      name = "hello_test",
      srcs = ["my_test.mojo"],
  )
  ```
### Attributes

| Name  | Description |
| :---- | :---------- |
| <a id="mojo_test-name"></a>`name` | <code><a href="https://bazel.build/concepts/labels#target-names">Name</a></code>, required.<br><br> A unique name for this target.   |
| <a id="mojo_test-deps"></a>`deps` | <code><a href="https://bazel.build/concepts/labels">List of labels</a></code>, optional, defaults to <code>[]</code>.<br><br> The dependencies for this target.<br><br>Use `ll_library` targets here. Other targets won't work.   |
| <a id="mojo_test-srcs"></a>`srcs` | <code><a href="https://bazel.build/concepts/labels">List of labels</a></code>, optional, defaults to <code>[]</code>.<br><br> Compilable source files for this target.<br><br>Allowed file extensions: `[".mojo", ".ð¥"]`.<br><br>Place headers in the `hdrs` attribute.   |
| <a id="mojo_test-compile_flags"></a>`compile_flags` | <code>List of strings</code>, optional, defaults to <code>[]</code>.<br><br> Flags for the compiler.<br><br>Pass a list of strings here. For instance `["-O3", "-std=c++20"]`.<br><br>Split flag pairs `-Xclang -somearg` into separate flags `["-Xclang", "-somearg"]`.<br><br>Unavailable to downstream targets.   |
| <a id="mojo_test-compile_string_flags"></a>`compile_string_flags` | <code><a href="https://bazel.build/concepts/labels">List of labels</a></code>, optional, defaults to <code>[]</code>.<br><br> Flags for the compiler in the form of `string_flag`s.<br><br>Splits the values of each `string_flag` along colons like so:<br><br><pre><code class="language-python">load("@bazel_skylib//rules:common_settings.bzl", "string_flag")&#10;&#10;string_flag(&#10;    name = "myflags",&#10;    build_setting_default = "a:b:c",&#10;)&#10;&#10;mojo_library(&#10;    # ...&#10;    # Equivalent to `compile_flags = ["a", "b", "c"]`&#10;    compile_string_flags = [":myflags"],&#10;)</code></pre><br><br>Useful for externally configurable build attributes, such as generated flags from Nix environments.   |
| <a id="mojo_test-defines"></a>`defines` | <code>List of strings</code>, optional, defaults to <code>[]</code>.<br><br> Defines for this target.<br><br>Pass a list of strings here. For instance `["MYDEFINE_1", "MYDEFINE_2"]`.<br><br>Unavailable to downstream targets.   |
| <a id="mojo_test-includes"></a>`includes` | <code>List of strings</code>, optional, defaults to <code>[]</code>.<br><br> Include paths, relative to the target workspace.<br><br>Uses `-iquote`.<br><br>Useful if you need custom include prefix stripping for dynamic paths, for instance the ones generated by `bzlmod`. Instead of `compile_flags = ["-iquoteexternal/mydep.someversion/include"]`, use `includes = ["include"]` to add the path to the workspace automatically.<br><br>Expands paths starting with `$(GENERATED)` to the workspace location in the `GENDIR` path.<br><br>Unavailable to downstream targets.   |
| <a id="mojo_test-runtime_data"></a>`runtime_data` | <code><a href="https://bazel.build/concepts/labels">List of labels</a></code>, optional, defaults to <code>[]</code>.<br><br> Extra files made available during test time.   |