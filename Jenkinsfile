@Library('xmos_jenkins_shared_library@v0.54.0') _

getApproval()

pipeline {
    agent {
        label 'linux&&64'
    }
    options {
        disableConcurrentBuilds()
        skipDefaultCheckout()
        timestamps()
        buildDiscarder(xmosDiscardBuildSettings())
    }
    parameters {
        string(
            name: 'TOOLS_VERSION_XS',
            defaultValue: '15.3.1',
            description: 'XS XTC tools version'
        )
        string(
            name: 'TOOLS_VERSION_VX',
            defaultValue: '-j --repo arch_vx_slipgate -b master -a XTC 131',
            description: 'VX4 XTC tools version'
        )
    }
    stages {
        stage('Checkout') {
            steps {
                println "Stage running on ${env.NODE_NAME}"
                script {
                    def (server, user, repo) = extractFromScmUrl()
                    env.REPO_NAME = repo
                }
                dir(REPO_NAME){
                    checkoutScmShallow()
                }
            }
        }  // stage('Checkout')

        stage('Library checks') {
            steps {
                //TODO this repo does not have a library structure, so these checks might not be fully applicable
                catchError(buildResult: 'SUCCESS', stageResult: 'SUCCESS', message: 'Repo checks failed') {
                    runRepoChecks("${WORKSPACE}/${REPO_NAME}")
                }
            }
        } // stage('Library checks')

        stage('Test setup') {
            steps {
                dir("${REPO_NAME}/test") {
                    createVenv(reqFile: 'requirements.txt')
                }
            }
        } // stage('Test setup')

        stage('Tests') {
            parallel {
                stage('XS3 test') {
                    steps {
                        dir("${REPO_NAME}/test") {
                            withVenv {
                                withTools(params.TOOLS_VERSION_XS) {
                                    runPytest('--toolchain xs2a')
                                    runPytest('--toolchain xs3a')
                                }
                            }
                        }
                    }
                } // stage('XS3 test')

                stage('VX4 test') {
                    steps {
                        dir("${REPO_NAME}/test") {
                            withVenv {
                                withTools(params.TOOLS_VERSION_VX) {
                                    runPytest('--toolchain vx4_xcc')
                                }
                            }
                        }
                    }
                } // stage('VX4 test')
            }
        } // stage('Tests')
    }

    post {
        cleanup {
            xcoreCleanSandbox()
        }
    }
}
