# edu-dsa

Educational repository for data structures assignments. Each assignment lives in its own top-level directory; student submissions and shared CI tests are kept separate.

## Repository layout

```
edu-dsa/
├── dev/                         # Instructor reference implementations
│   └── reference/
│       ├── inc/                 # Public headers
│       └── src/                 # Source files
├── SWB-04/                      # Assignment 04
│   └── <student-name>/
│       ├── inc/
│       └── src/
├── SWB-05/                      # Assignment 05
│   └── <student-name>/
│       ├── inc/
│       └── src/
├── tests/                       # Shared automated tests (run in CI)
│   └── SWB-04/                  # Google Test suites for assignment SWB-04
├── scripts/                     # lint, build, and test helpers
└── .github/workflows/ci.yml     # CI pipeline
```

Every submission directory must contain:

- `inc/` — header files (`.h`)
- `src/` — implementation files (`.c`)

## CI pipeline

GitHub Actions runs three sequential stages:

1. **Lint** — [cpplint](https://github.com/cpplint/cpplint) (Google style) on the submission
2. **Build** — CMake compile of the selected submission
3. **Test** — [Google Test](https://github.com/google/googletest) via CTest

Default CI target on push/PR:

- Assignment tests: `SWB-04`
- Submission: `dev/reference`

You can also trigger CI manually (**Actions → CI → Run workflow**) and pass:

- `assignment` — which test suite to run (e.g. `SWB-04`)
- `submission` — which code to build (e.g. `SWB-04/john-doe` or `dev/reference`)

## Local development

Install `cmake`, `g++`, `clang`, and `cpplint` (`pip install cpplint`), then:

```bash
# Lint a student submission
./scripts/lint.sh SWB-04 john-doe

# Build and test a student submission
./scripts/test.sh SWB-04 john-doe

# Build and test the instructor reference against SWB-04 tests
./scripts/test.sh SWB-04 ignored dev/reference
```

Or with CMake directly:

```bash
cmake -S . -B build \
  -DEDU_ASSIGNMENT=SWB-04 \
  -DEDU_SUBMISSION=dev/reference

cmake --build build --parallel
ctest --test-dir build --output-on-failure
```

## Adding a new assignment

1. Create `SWB-XX/` at the repo root.
2. Add student folders under it, each with `inc/` and `src/`.
3. Add matching Google Test files under `tests/SWB-XX/` (e.g. `test_*.cpp`).
4. Trigger CI with `assignment=SWB-XX` and the desired `submission` path.

## Adding a student submission

1. Create `SWB-XX/<student-name>/inc` and `SWB-XX/<student-name>/src`.
2. Implement the required headers and source files for that assignment.
3. Run `./scripts/test.sh SWB-XX <student-name>` locally before pushing.
