@Library('dst-shared@master') _

//Possible Parameters Include
// * executeScript         Name of script which creates .tar file
// * executeScript2        Name of script which creates CLI .md files
// * dockerfile            Path to the Docker file relative to the repository root.  Default Dockerfile
// * dockerBuildContextDir The build context directory for Docker builds.  Default to '.' i.e. workspace root
// * dockerArguments       Additional arguments to pass to the build of the Docker application
// * dockerBuildTarget     Target to build when building the Docker application. Defaults to unset
// * masterBranch          Branch to consider as master, only this branch will receive the latest tag.  Default master
// * repository            Docker repository name to use
// * imagePrefix           Docker image name prefix
// * app                   Docker image name suffix
// * name                  Name of the Docker image used to add metadata to the image
// * description           Description of the Docker image used to add metadata to the image
// * slackNotification     Array: ["<slack_channel>", "<jenkins_credential_id", <notify_on_start>, <notify_on_success>, <notify_on_failure>, <notify_on_fixed>]]
// * product               String: set product for the transfer function
// * targetOS              String: set targetOS for the transfer function

// Jenkins library for building docker files
// Copyright 2019 Cray Inc. All rights reserved.


def pipelineParams= [
    executeScript: "createTar.sh",
    makeMakefile: "docs/portal/developer-portal/Makefile",
    dockerfile: "Dockerfile",
    //dockerfileSpell: "Dockerfile.spellcheck",
    repository: "shs",
    imagePrefix: "shsdocs",
    app: "website",
    name: "shsdocs",
    description: "Standalone Slingshot Host Software Docs",
    masterBranch: 'main',
    dockerbuild: false,
    dockerBuildContextDir: '.',
    dockerArguments: "",
    dockerBuildTarget: "application",
    useEntryPointForTest: true,
    product: "slingshot-host-software",
    targetOS: "noos"
]

// Build date
def buildDate = new Date().format( 'yyyyMMddHHmmss' )

// UUID distinguishes base containers
def containerId = UUID.randomUUID().toString()

// UUID distinguishes base containers
def containerId_sq = UUID.randomUUID().toString()

// Container Used for spellcheck.
//def containerId_toss = UUID.randomUUID().toString()

// Variable to check whether to skip the 'success' post section
def skipSuccess = false

// Set cron to build nightly for master or release, not other branches
def relpattern = /release/
String cron_str = BRANCH_NAME == "master" || BRANCH_NAME ==~ relpattern ? "H H(0-7) * * *" : ""

pipeline {
    agent { node { label 'dstbuild' } }

    triggers { cron(cron_str) }

    // Configuration options applicable to the entire job
    options {
        // This build should not take long, fail the build if it appears stuck
        timeout(time: 120, unit: 'MINUTES')

        // Don't fill up the build server with unnecessary cruft
        buildDiscarder(logRotator(numToKeepStr: '10'))

        // Add timestamps and color to console output, cuz pretty
        timestamps()
    }

    environment {
        VERSION = sh(returnStdout: true, script: 'chmod +x setup_versioning.sh && ./setup_versioning.sh; cat .version').trim()
        VERSION_RPM = sh(returnStdout: true, script: "cat .version_rpm").trim()
        GIT_TAG = sh(returnStdout: true, script: "git rev-parse --short HEAD").trim()
        BUILD_DATE = "${buildDate}" 
        IMAGE_TAG = getDockerImageTag(version: "${VERSION}", buildDate: "${BUILD_DATE}", gitTag: "${GIT_TAG}")
        IMAGE_NAME = "${pipelineParams.imagePrefix}-directory-${IMAGE_TAG}"
        IMAGE_NAME_PDFHTML = "${pipelineParams.imagePrefix}-pdfhtml-${IMAGE_TAG}"
        IMAGE_NAME_PDF = "${pipelineParams.imagePrefix}-pdf-${IMAGE_TAG}"
        IMAGE_NAME_HTML = "${pipelineParams.imagePrefix}-html-${IMAGE_TAG}"
        IMAGE_NAME_MAN = "${pipelineParams.imagePrefix}-man-${IMAGE_TAG}"
        IMAGE_NAME_MD = "${pipelineParams.imagePrefix}-md-${IMAGE_TAG}"
        IMAGE_VERSIONED = getDockerImageReference(repository: "${pipelineParams.repository}", imageName: "${pipelineParams.imagePrefix}-${pipelineParams.app}", imageTag: "${IMAGE_TAG}", product: "${pipelineParams.product}")
        IMAGE_LATEST = getDockerImageReference(repository: "${pipelineParams.repository}", imageName: "${pipelineParams.imagePrefix}-${pipelineParams.app}", imageTag: "latest", product: "${pipelineParams.product}")
        LATEST = sh(returnStdout: true, script: "./setup_versioning.sh;cat .version | cut -d '.' -f 1-2").trim()
        LATEST_IMAGE_NAME = "${pipelineParams.imagePrefix}-directory-${LATEST}-LATEST"
        TEST_IMAGE_VERSIONED = getDockerImageReference(repository: "${pipelineParams.repository}", imageName: "${pipelineParams.imagePrefix}-${pipelineParams.app}-test", imageTag: "${IMAGE_TAG}", product: "${pipelineParams.product}")
        TEST_IMAGE_LATEST = getDockerImageReference(repository: "${pipelineParams.repository}", imageName: "${pipelineParams.imagePrefix}-${pipelineParams.app}-test", imageTag: "latest", product: "${pipelineParams.product}")
        PRODUCT = "${pipelineParams.product}"
        PRODUCT_NAME = "shs-docs"
        TARGET_OS = "${pipelineParams.targetOS}"
        TARGET_ARCH = "noarch"
        HPE_GITHUB_TOKEN = credentials('ghe_jenkins_token')
    }

    stages {
        // For debugging
        stage('Print Build Info') {
            steps {
                printBuildInfo(pipelineParams)
                script {
                        echo "Print all Environment Variables"
                        sh "env | sort"
                    }
            }
        }
        stage('Workdir Preparation') {
            steps {
                sh "mkdir -p build"
                echo "Docker image tag for this build is ${IMAGE_TAG}"
                echo "Docker image reference for this build is ${IMAGE_VERSIONED}"
            }
        }
        
        stage('Import Yaml File') {
            steps {
                sh """
                  if [ ! -f ${pipelineParams.executeScript3} ]; then
                        echo \"ERROR: ${pipelineParams.executeScript3} does not exist\" >&2
                  else
                        sh -x ${pipelineParams.executeScript3}
                  fi
                """
            }
        }

        stage('Check Docker File') {
            steps {
                sh """
                    if [ ! -f ${pipelineParams.dockerfile} ]; then
                        echo \"ERROR: ${pipelineParams.dockerfile} does not exist\"
                        exit 1;
                    fi
                """
            }
        }

        stage('Build PDF HTML') {
            environment {
                BUILD_DATE = "${buildDate}" 
            }
            steps {
            // Build MD PDF HTML
                withCredentials([
                    usernamePassword(credentialsId: 'REDOC_LICENSE', usernameVariable: 'REDOC_USER', passwordVariable: 'REDOC_LICENSE_PW')])
                    {
                    sh """
                        set -x
                        if [[ -f ${pipelineParams.makeMakefile} ]]; then
                            mkdir -p ${WORKSPACE}/build/results
                            cd docs/portal/developer-portal;make set-permissions && make dita_ot_tar
                            cp build/*.tar ${WORKSPACE}/build/results/${IMAGE_NAME_PDFHTML}.tar
                            cp ${WORKSPACE}/build/results/${IMAGE_NAME_PDFHTML}.tar ${WORKSPACE}/build/results/${PRODUCT_NAME}-pdfhtml-${LATEST}-LATEST.tar
                            cp build/pdf ${WORKSPACE}/build/results/${IMAGE_NAME_PDF} -rf
                            cp build/html ${WORKSPACE}/build/results/${IMAGE_NAME_HTML} -rf
                            cp build/md ${WORKSPACE}/build/results/${IMAGE_NAME_MD} -rf
                        else
                            echo "${pipelineParams.makeMakefile} doesn't exist"
                            exit 1
                        fi
                        """
                    }
            }
        }

        // Generate docker image
        stage('Build both Docker image and tar file') {
            parallel {
                stage('Parallel Container Build') {
                    when { expression { pipelineParams.dockerbuild } }
                    stages('Build and Create Docker Container') {
                        stage('Build') {
                            environment {
                                BUILD_DATE = "${buildDate}" 
                            }
                            steps {
                                // Build docker image
                                labelAndBuildDockerImage(
                                    name: "${pipelineParams.name}",
                                    description: "${pipelineParams.description}",
                                    dockerfile: "${pipelineParams.dockerfile}",
                                    dockerBuildContextDir: "${pipelineParams.dockerBuildContextDir}",
                                    dockerArguments: "${pipelineParams.dockerArguments}",
                                    dockerBuildTarget: "${pipelineParams.dockerBuildTarget}",
                                    imageReference: "${IMAGE_VERSIONED}",
                                    masterBranch: "${pipelineParams.masterBranch}",
                                    tarball: "${pipelineParams.app}")
                            }
                        }

                        // Generate '.tar.gz' file of the image
                        stage('Generate Docker Image Tarball') {
                            steps {
                                dockerRetagAndSave(
                                    imageReference: "${IMAGE_VERSIONED}",
                                    imageRepo: "sms.local:5000",
                                    imageName: "${pipelineParams.imagePrefix}-${pipelineParams.app}",
                                    imageTag: "${IMAGE_TAG}",
                                    repository: "${pipelineParams.repository}")
                            }
                        }

                        stage('Publish') {
                        // For Master branch builds, send the artifacts to the artifact repository and internal docker registry
                            steps {
                                echo "Log Stash: dockerBuildPipeline - Publish"
                                publishDockerImage(
                                    image: "${IMAGE_VERSIONED}",
                                    imageTag: "${IMAGE_TAG}",
                                    repository: "${pipelineParams.repository}",
                                    imagePrefix: "${pipelineParams.imagePrefix}",
                                    app: "${pipelineParams.app}",
                                    masterBranch: "${pipelineParams.masterBranch}")

                            }
                        }
                    }
                    post {
                        always {
                            // Once the image has been pushed, lets untag it so it's not sitting around and consuming
                            // valuable hardware space.
                            cleanupDockerImages( image: env.IMAGE_VERSIONED,
                                                imageTag: env.IMAGE_TAG,
                                                imageLatest: env.IMAGE_LATEST,
                                                repository: "${pipelineParams.repository}",
                                                imagePrefix: "${pipelineParams.imagePrefix}",
                                                app: "${pipelineParams.app}",
                                                masterBranch: "${pipelineParams.masterBranch}"
                                               )
                        }
                    }
                }
                stage('Parallel Source Tar File Creation') {
                    stages('Build and Create Source Tar File') {
                        stage('Build Base Image') {
                            steps {
                                 sh """
                                 docker build -t basecontainer-${containerId_sq} --target base -f ${pipelineParams.dockerfile} .
                                 """
                                 }
                        }
                        
                        stage('Create Tar and RPM File') {
                            steps {
                                withCredentials([
                                    usernamePassword(credentialsId: 'REDOC_LICENSE', usernameVariable: 'REDOC_USER', passwordVariable: 'REDOC_LICENSE_PW')]) 
                                    {
                                        sh """
                                        if [[ -f ${pipelineParams.executeScript} ]]; then
                                            mkdir -p ${WORKSPACE}/build/results
                                            
                                                docker run --rm -v ${WORKSPACE}:/root/ -v ${WORKSPACE}/build/results:${WORKSPACE}/build/results basecontainer-${containerId_sq} /bin/sh /root/${pipelineParams.executeScript} ${IMAGE_NAME} ${WORKSPACE}/build/results \"${REDOC_LICENSE_PW}\"
                                                docker run --rm -v ${WORKSPACE}:/root/ -v ${WORKSPACE}/build/results:${WORKSPACE}/build/results basecontainer-${containerId_sq} /bin/sh /root/${pipelineParams.executeScript} ${LATEST_IMAGE_NAME} ${WORKSPACE}/build/results \"${REDOC_LICENSE_PW}\"
                                        else
                                            echo "${pipelineParams.executeScript} doesn't exist"
                                            exit 1
                                        fi
                                        """ 
                                    }
                            }
                        }
                    }
                    post("Docker Cleanup"){
                        always {
                            sh """
                                docker rmi basecontainer-${containerId_sq}
                            """
                        }
                    }
                }
            }
        }
        stage('Start Container') {
            environment {
            VERSION = "${env.VERSION_RPM}" 
            }
            steps {
                sh "docker run --name ${containerId} -it -d --env BUILD_NUMBER --env VERSION -v ${WORKSPACE}:/home/jenkins/ -w=\"/home/jenkins/\" --privileged  arti.hpc.amslabs.hpecorp.net/dstbuildenv-docker-master-local/cray-sle15sp3_build_environment:latest /bin/bash"
            }
        }

        
        stage('Create RPM') {
            steps {
                echo "Log Stash: rpmBuildPipeline - RPM Build From SPEC File"
                echo "Build"
                sh """
                cd docs/portal/developer-portal  
                cp  ${WORKSPACE}/build/results/${IMAGE_NAME_PDF} pdf -rf
                cp  ${WORKSPACE}/build/results/${IMAGE_NAME_HTML} html -rf
                cp  ${WORKSPACE}/build/results/${IMAGE_NAME_MD} md -rf
                docker exec ${containerId} sh ./docs/portal/scripts/make_package.sh
                cp -r rpmbuild/RPMS/x86_64/*.rpm ${WORKSPACE}/build/results
                """       
            }
        }
    
        stage ("Sign RPMS") {
            when { expression {BRANCH_NAME ==~ /release\/.*/}}
            steps {
                signArtifacts([artifacts: "${WORKSPACE}/build/results/"])
            }
        } 
           
        stage('Transfer') {
            steps {
                script {
                    if ( checkFileExists(filePath: 'build/results/*.tar.gz') ) {
                        transfer(artifactName: "build/results/*.tar.gz")
                    }
                    if ( checkFileExists(filePath: 'build/results/*.tar') ) {
                        transfer(artifactName: "build/results/*.tar")
                    }
                    if ( checkFileExists(filePath: 'build/results/*.rpm') ) {
                        transfer(artifactName: "build/results/*.rpm")
                    }
                }
            }
        }
    }
    post('Post-build steps') {
        always {
            script {
                currentBuild.result = currentBuild.result == null ? "SUCCESS" : currentBuild.result
            }
            script {
                     
                sh """
                    docker stop ${containerId}
                    docker rm ${containerId}
                """
                     
            }
        }
        fixed {
            notifyBuildResult(headline: "FIXED")
            
        }
        failure {
            notifyBuildResult(headline: "FAILED")  
        }

    }
}

