@Library('xmos_jenkins_shared_library@v0.27.0') _

getApproval()

pipeline {
    agent {
        label 'x86_64&&macOS' // These agents have 24 cores so good for parallel xsim runs
    }

    options {
        disableConcurrentBuilds()
        skipDefaultCheckout()
        timestamps()
        // on develop discard builds after a certain number else keep forever
        buildDiscarder(logRotator(
            numToKeepStr:         env.BRANCH_NAME ==~ /develop/ ? '25' : '',
            artifactNumToKeepStr: env.BRANCH_NAME ==~ /develop/ ? '25' : ''
        ))
    }
    parameters {
        string(
            name: 'TOOLS_VERSION',
            defaultValue: '15.2.1',
            description: 'The XTC tools version'
        )
    }
    environment {
        REPO = 'xmos_cmake_toolchain'
        PYTHON_VERSION = "3.10.5"
        VENV_DIRNAME = ".venv"
    }

    stages {
        stage('Get repo') {
            steps {
                sh "mkdir ${REPO}"
                // source checks require the directory
                // name to be the same as the repo name
                dir("${REPO}") {
                    // checkout repo
                    checkout scm
                    sh 'git submodule update --init --recursive --depth 1'
                }
            }
        }
        stage ("Create Python environment") {
            steps {
                dir("${REPO}") {
                    createVenv('requirements.txt')
                    withVenv {
                        sh 'pip install -r requirements.txt'
                    }
                }
            }
        }
        stage('Library checks') {
            steps {
                dir("${REPO}") {
                    sh 'git clone git@github.com:xmos/infr_apps.git'
                    sh 'git clone git@github.com:xmos/infr_scripts_py.git'
                    withVenv {
                        sh 'pip install -e infr_scripts_py'
                        sh 'pip install -e infr_apps'
                        dir("tests") {
                            withEnv(["XMOS_ROOT=.."]) {
                                localRunPytest('-s test_lib_checks.py -vv')
                                junit 'tests/results.xml'
                            }
                        }
                    }
                }
            }
        }
    }
    post {
        cleanup {
            xcoreCleanSandbox()
        }
    }
}
