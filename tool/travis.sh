#!/bin/bash
# Created with package:mono_repo v2.0.0

if [[ -z ${PKGS} ]]; then
  echo -e '\033[31mPKGS environment variable must be set!\033[0m'
  exit 1
fi

if [[ "$#" == "0" ]]; then
  echo -e '\033[31mAt least one task argument must be provided!\033[0m'
  exit 1
fi

EXIT_CODE=0

for PKG in ${PKGS}; do
  echo -e "\033[1mPKG: ${PKG}\033[22m"
  pushd "${PKG}" || exit $?
  pub upgrade --no-precompile || exit $?

  for TASK in "$@"; do
    case ${TASK} in
    dartanalyzer) echo
      echo -e '\033[1mTASK: dartanalyzer\033[22m'
      echo -e 'dartanalyzer --fatal-infos --fatal-warnings .'
      dartanalyzer --fatal-infos --fatal-warnings . || EXIT_CODE=$?
      ;;
    dartfmt) echo
      echo -e '\033[1mTASK: dartfmt\033[22m'
      echo -e 'dartfmt -n --set-exit-if-changed .'
      dartfmt -n --set-exit-if-changed . || EXIT_CODE=$?
      ;;
    test_0) echo
      echo -e '\033[1mTASK: test_0\033[22m'
      echo -e 'pub run test'
      pub run test || EXIT_CODE=$?
      ;;
    test_1) echo
      echo -e '\033[1mTASK: test_1\033[22m'
      echo -e 'pub run test -j 1 -x requires-edge-sdk --run-skipped'
      pub run test -j 1 -x requires-edge-sdk --run-skipped || EXIT_CODE=$?
      ;;
    test_2) echo
      echo -e '\033[1mTASK: test_2\033[22m'
      echo -e 'pub run test -t requires-edge-sdk --run-skipped'
      pub run test -t requires-edge-sdk --run-skipped || EXIT_CODE=$?
      ;;
    *) echo -e "\033[31mNot expecting TASK '${TASK}'. Error!\033[0m"
      EXIT_CODE=1
      ;;
    esac
  done

  popd
done

exit ${EXIT_CODE}
