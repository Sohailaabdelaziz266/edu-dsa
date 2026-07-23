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
│   └── SWB-04/                  # One Google Test suite per assignment
├── scripts/                     # lint, build, and test helpers
└── .github/workflows/ci.yml     # CI pipeline
```

Every submission directory must contain:

- `inc/` — header files (`.h`)
- `src/` — implementation files (`.c`)

## Build model

There is **one shared test suite** per assignment under `tests/<assignment>/`.

Each submission gets its **own compiled library and test binary**:

```
tests/SWB-04/test_list.cpp          # shared test source
        │
        ├── test_list_example-student  → links submission_example-student
        └── test_list_dev-reference    → links submission_dev-reference
```

CMake auto-discovers every `SWB-XX/<student-name>/` directory and also includes extra submissions from `EDU_EXTRA_SUBMISSIONS` (default: `dev/reference`).

## CI pipeline

GitHub Actions runs three sequential stages:

1. **Lint** — [cpplint](https://github.com/cpplint/cpplint) on every submission
2. **Build** — one library and one test binary per submission
3. **Test** — [Google Test](https://github.com/google/googletest) via CTest for every submission

Default CI target on push/PR: assignment `SWB-04`, all discovered submissions.

## Local development

Install `cmake`, `g++`, `clang`, and `cpplint` (`pip install cpplint`), then:

```bash
# Lint all submissions for an assignment
./scripts/lint.sh SWB-04

# Lint one student
./scripts/lint.sh SWB-04 john-doe

# Build all student binaries and run all tests
./scripts/test.sh SWB-04

# Build all, but run tests for one submission only
./scripts/test.sh SWB-04 example-student
```

Or with CMake directly:

```bash
cmake -S . -B build/SWB-04 -DEDU_ASSIGNMENT=SWB-04
cmake --build build/SWB-04 --parallel
ctest --test-dir build/SWB-04 --output-on-failure
```

Build a subset of submissions:

```bash
cmake -S . -B build/SWB-04 \
  -DEDU_ASSIGNMENT=SWB-04 \
  -DEDU_STUDENTS="example-student;dev-reference"
```

## Adding a new assignment

1. Create `SWB-XX/` at the repo root.
2. Add student folders under it, each with `inc/` and `src/`.
3. Add one shared Google Test file under `tests/SWB-XX/` (e.g. `test_*.cpp`).
4. Trigger CI with `assignment=SWB-XX`.

## Adding a student submission

1. Create `SWB-XX/<student-name>/inc` and `SWB-XX/<student-name>/src`.
2. Implement the required headers and source files for that assignment.
3. Rebuild — CMake will automatically create `submission_<student-name>` and `test_list_<student-name>`.
4. Run `./scripts/test.sh SWB-XX <student-name>` locally before pushing.
