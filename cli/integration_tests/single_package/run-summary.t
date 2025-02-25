Setup
  $ . ${TESTDIR}/../setup.sh
  $ . ${TESTDIR}/setup.sh $(pwd)

Check
  $ ${TURBO} run build --summarize > /dev/null
  $ test -d .turbo/runs
  $ ls .turbo/runs/*.json | wc -l
  \s*1 (re)

  $ source "$TESTDIR/../run-summary-utils.sh"
  $ SUMMARY=$(/bin/ls .turbo/runs/*.json | head -n1)
  $ TASK_SUMMARY=$(getSummaryTask "$SUMMARY" "build")

  $ cat $SUMMARY | jq '.tasks | length'
  1
  $ cat $SUMMARY | jq '.version'
  "0"
  $ cat $SUMMARY | jq '.execution | keys'
  [
    "attempted",
    "cached",
    "endTime",
    "exitCode",
    "failed",
    "startTime",
    "success"
  ]

  $ cat $SUMMARY | jq '.execution.exitCode'
  0
  $ cat $SUMMARY | jq '.execution.attempted'
  1
  $ cat $SUMMARY | jq '.execution.cached'
  0
  $ cat $SUMMARY | jq '.execution.failed'
  0
  $ cat $SUMMARY | jq '.execution.success'
  1
  $ cat $SUMMARY | jq '.execution.startTime'
  [0-9]+ (re)
  $ cat $SUMMARY | jq '.execution.endTime'
  [0-9]+ (re)

  $ echo $TASK_SUMMARY | jq 'keys'
  [
    "cache",
    "cliArguments",
    "command",
    "dependencies",
    "dependents",
    "environmentVariables",
    "excludedOutputs",
    "execution",
    "expandedOutputs",
    "framework",
    "hash",
    "hashOfExternalDependencies",
    "inputs",
    "logFile",
    "outputs",
    "resolvedTaskDefinition",
    "task"
  ]

  $ echo $TASK_SUMMARY | jq '.execution'
  {
    "startTime": [0-9]+, (re)
    "endTime": [0-9]+, (re)
    "error": null,
    "exitCode": 0
  }
  $ echo $TASK_SUMMARY | jq '.cliArguments'
  []
  $ echo $TASK_SUMMARY | jq '.expandedOutputs'
  [
    ".turbo/turbo-build.log",
    "foo"
  ]
  $ echo $TASK_SUMMARY | jq '.cache'
  {
    "local": false,
    "remote": false
  }
