# Copyright 2019 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# buildifier: disable=module-docstring
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//wasm_bindgen/3rdparty/crates:defs.bzl", "crate_repositories")

WASM_BINDGEN_VERSION = "0.2.82"

# buildifier: disable=unnamed-macro
def rust_wasm_bindgen_dependencies():
    """Declare dependencies needed for the `rules_rust` [wasm-bindgen][wb] rules.

    [wb]: https://github.com/rustwasm/wasm-bindgen
    """

    maybe(
        http_archive,
        name = "rules_rust_wasm_bindgen_cli",
        sha256 = "893e72ed18214125f4c9f0476e5205f96725f9d087b1c1bd0f26af13e0c11d4f",
        urls = ["https://crates.io/api/v1/crates/wasm-bindgen-cli/{}/download".format(WASM_BINDGEN_VERSION)],
        type = "tar.gz",
        strip_prefix = "wasm-bindgen-cli-{}".format(WASM_BINDGEN_VERSION),
        build_file = Label("//wasm_bindgen/3rdparty:BUILD.wasm-bindgen-cli.bazel"),
    )

    maybe(
        http_archive,
        name = "rules_nodejs",
        sha256 = "017e2348bb8431156d5cf89b6f502c2e7fcffc568729f74f89e4a12bd8279e90",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.5.2/rules_nodejs-core-5.5.2.tar.gz"],
    )

    crate_repositories()

# buildifier: disable=unnamed-macro
def rust_wasm_bindgen_register_toolchains(register_toolchains = True):
    """Registers the default toolchains for the `rules_rust` [wasm-bindgen][wb] rules.

    [wb]: https://github.com/rustwasm/wasm-bindgen

    Args:
        register_toolchains (bool, optional): Whether or not to register toolchains.
    """

    if register_toolchains:
        native.register_toolchains(str(Label("//wasm_bindgen:default_wasm_bindgen_toolchain")))

# buildifier: disable=unnamed-macro
def rust_wasm_bindgen_repositories(register_default_toolchain = True):
    """Declare dependencies needed for [rust_wasm_bindgen](#rust_wasm_bindgen).

    **Deprecated**: Use [rust_wasm_bindgen_dependencies](#rust_wasm_bindgen_depednencies) and [rust_wasm_bindgen_register_toolchains](#rust_wasm_bindgen_register_toolchains).

    Args:
        register_default_toolchain (bool, optional): If True, the default [rust_wasm_bindgen_toolchain](#rust_wasm_bindgen_toolchain)
            (`@rules_rust//wasm_bindgen:default_wasm_bindgen_toolchain`) is registered. This toolchain requires a set of dependencies
            that were generated using [cargo raze](https://github.com/google/cargo-raze). These will also be loaded.
    """

    rust_wasm_bindgen_dependencies()

    rust_wasm_bindgen_register_toolchains(register_toolchains = register_default_toolchain)
