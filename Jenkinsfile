@Library('xmos_jenkins_shared_library@v0.54.0') _

getApproval()

def runToolTest(toolchain, toolsVersionName) {
    stage("${toolchain} test") {
        try {
            dir("${REPO_NAME}/test") {
                withVenv {
                    withTools(params[toolsVersionName]) {
                        runPytest("--toolchain ${toolchain}")
                    }
                }
            }
        } finally {
            uninstallTools(params[toolsVersionName])
        }
    }
}

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
        string(
         name: 'TOOLS_VERSION_RV',
            defaultValue: 'bob@develop',
            description: 'VX New tools version'
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
        
        stage('Test setup') {
            steps {
                dir("${REPO_NAME}/test") {
                    createVenv(reqFile: 'requirements.txt')
                }
            }
        } // stage('Test setup')

        stage('Tests') {
            steps {
                script {
                    parallel(
                        xs2a: { runToolTest('xs2a', 'TOOLS_VERSION_XS') },
                        xs3a: { runToolTest('xs3a', 'TOOLS_VERSION_XS') },
                        vx4_xcc: { runToolTest('vx4_xcc', 'TOOLS_VERSION_VX') },
                        vx4_clang: { runToolTest('vx4_clang', 'TOOLS_VERSION_RV') }
                    )
                }
            }
        } // stage('Tests')
    }

    post {
        cleanup {
            xcoreCleanSandbox()
        }
    }
}
