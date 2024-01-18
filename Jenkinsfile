pipeline {
    agent {
        label 'cloud-slave'
    }

    tools {
        go '1.21.x'
    }

    options {
        disableConcurrentBuilds()
        timestamps()
        ansiColor('xterm')
    }

    environment {
        TF_WORKDIR = './examples/basic'
    }

    stages {
        stage('checkout') {
            steps {
                // Delete the entire workspace
                deleteDir()

                script {
                    // we checkout the branch that was triggering us:
                    checkout scm
                }

                sh '''#! /usr/bin/env bash
                    set -xeo pipefail
                    echo 'checkout ...'
                    git pull origin $BRANCH_NAME --tags
                    git tag
                    uname -a
                    env
                    pwd
                    ls -al
                    echo '... checkout'
                '''
            }
        }

        stage('tools') {
            steps {
                sh '''#! /usr/bin/env bash
                    set -xeo pipefail
                    echo tools ...
                    uname -a

                    git --version

                    rm -rf .artifacts
                    mkdir .artifacts
                    cp Jenkinsfile .artifacts/Jenkinsfile

                    rm -rf .tools
                    mkdir .tools
                    cd .tools
                    PATH=${WORKSPACE}/.tools:$PATH
                    echo $PATH

                    ARCH=amd64

                    curl -sSLo terraform.zip https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_${ARCH}.zip \
                        && unzip terraform.zip \
                        && chmod +x terraform \
                        && rm terraform.zip \
                        && terraform --version

                    curl -sSLo terraform-docs.tar.gz https://terraform-docs.io/dl/v0.16.0/terraform-docs-v0.16.0-Linux-${ARCH}.tar.gz \
                        && tar -xzvf terraform-docs.tar.gz \
                        && chmod +x terraform-docs \
                        && rm terraform-docs.tar.gz \
                        && terraform-docs --version

                    curl -sSLo tfsec "https://github.com/aquasecurity/tfsec/releases/download/v1.28.4/tfsec-linux-${ARCH}" \
                        && chmod +x tfsec \
                        && tfsec --version

                    curl -sSLo tflint.zip "https://github.com/terraform-linters/tflint/releases/download/v0.49.0/tflint_linux_${ARCH}.zip" \
                        && unzip tflint.zip \
                        && chmod +x tflint \
                        && rm tflint.zip \
                        && tflint --version

                    ls -al .

                    echo ... tools
                '''
            }
        }

        stage('validate') {
            parallel {
                stage('tf fmt') {
                    steps {
                        sh '''#! /usr/bin/env bash
                            set -xeo pipefail
                            PATH=${WORKSPACE}/.tools:$PATH
                            echo terraform fmt ...

                            terraform --version
                            terraform fmt -recursive -check
                            if [[ $? -ne 0 ]]; then
                                exit 1
                            fi

                            echo ... terraform fmt
                        '''
                    }
                }

                stage('tf docs') {
                    steps {
                        sh '''#! /usr/bin/env bash
                            set -xeo pipefail
                            PATH=${WORKSPACE}/.tools:$PATH
                            echo terraform-docs ...

                            pwd
                            ls -al
                            terraform-docs --version
                            status=0
                            terraform-docs markdown table . --output-check --output-file README.md || status=$?
                            if [[ $status -ne 0 ]]; then
                            echo "terraform-docs: README.md is out of date. Please update README.md running 'terraform-docs markdown table . --output-file README.md'."
                            cp README.md README_original.md
                            terraform-docs markdown table . --output-file README.md
                            mv README.md README_corrected.md
                            git --no-pager diff --no-index README_original.md README_corrected.md || true
                            cp README_corrected.md $WORKSPACE/.artifacts/README_corrected.md
                            exit 1
                            fi

                            cd $TF_WORKDIR
                            pwd
                            ls -al
                            terraform-docs --version
                            status=0
                            terraform-docs markdown table . --output-check --output-file README.md || status=$?
                            if [[ $status -ne 0 ]]; then
                            echo "terraform-docs: README.md is out of date. Please update README.md running 'terraform-docs markdown table . --output-file README.md'."
                            cp README.md README_original.md
                            terraform-docs markdown table . --output-file README.md
                            mv README.md README_corrected.md
                            git --no-pager diff --no-index README_original.md README_corrected.md || true
                            cp README_corrected.md $WORKSPACE/.artifacts/README_corrected.md
                            exit 1
                            fi

                            echo ... terraform-docs
                        '''
                    }
                }

                stage('tf lint') {
                    steps {
                        sh '''#! /usr/bin/env bash
                            set -xeo pipefail
                            PATH=${WORKSPACE}/.tools:$PATH
                            echo terraform tflint ...

                            tflint --version
                            tflint --init
                            tflint --format=compact --chdir . || true
                            tflint --format=sarif --chdir . | tee $WORKSPACE/.artifacts/tflint.sarif
                            if [[ $? -ne 0 ]]; then
                                exit 1
                            fi

                            cd $TF_WORKDIR
                            tflint --version
                            tflint --init
                            tflint --format=compact --chdir . || true
                            tflint --format=sarif --chdir . | tee $WORKSPACE/.artifacts/tflint.sarif
                            if [[ $? -ne 0 ]]; then
                                exit 1
                            fi

                            echo ... terraform tflint
                        '''
                    }
                }

                stage('tf sec') {
                    steps {
                        sh '''#! /usr/bin/env bash
                            set -xeo pipefail
                            PATH=${WORKSPACE}/.tools:$PATH
                            echo terraform tfsec ...

                            tfsec --version
                            tfsec . | tee $WORKSPACE/.artifacts/tfsec.sarif
                            if [[ $? -ne 0 ]]; then
                                exit 1
                            fi

                            echo ... terraform tfsec
                        '''
                    }
                }

                stage('tf validate') {
                    steps {
                        dir("${env.TF_WORKDIR}") {
                            sh '''#! /usr/bin/env bash
                                set -xeo pipefail
                                PATH=${WORKSPACE}/.tools:$PATH
                                echo terraform validate ...

                                terraform --version
                                terraform init -upgrade
                                ls -al
                                ls -al .terraform

                                terraform validate | tee $WORKSPACE/.artifacts/terraform-validate.sarif
                                if [[ $? -ne 0 ]]; then
                                    exit 1
                                fi

                                echo ... terraform validate
                            '''
                        }
                    }
                }
            }
        }

        stage('tf test') {
            steps {
                withAWS(credentials: 'jenkins-lms-terraform', role: 'arn:aws:iam::967720414056:role/sts-developer', region: 'eu-central-1') {
                    sh '''#! /usr/bin/env bash
                        set -xeo pipefail
                        PATH=${WORKSPACE}/.tools:$PATH
                        echo test ...

                        aws configure list
                        aws sts get-caller-identity

                        go version
                        go env -w GOPROXY=https://proxy.golang.org,direct
                        go env
                        go get ./...
                        go mod tidy
                        pwd
                        ls -al
                        status=0
                        go test -timeout 30m -v ./test/integration | tee $WORKSPACE/.artifacts/test-results.txt || status=$?
                        if [[ $status -ne 0 ]]; then
                        echo "At least one test failed!"
                        exit 1
                        fi

                        echo ... test
                    '''
                }
            }
        }

        // Requires installation of Jenkin's Git Changelog Plugin: https://plugins.jenkins.io/git-changelog/
        // Bumps version automatically to next major/minor/patch number if commit message starts with breaking/feat/fix.
        // Examples of conventional commit messages:
        // - "doc(ALS-12345): improve documentation": 1.2.0 → 1.2.0 (no version bump)
        // - "chore(ALS-12345): improve logging": 1.2.0 → 1.2.0 (no version bump)
        // - "fix(ALS-12345): minor bug fix": 1.2.0 → 1.2.1 (increment in the patch version)
        // - "feature(ALS-12345): add a new feature": 1.2.0 → 1.3.0 (increment in the minor version)
        // - "breaking(ALS-12345): reimplement": 1.2.0 → 2.0.0 (increment in the major version)
        stage('git tag') {
            when {
                anyOf {
                    branch 'master'
                    branch 'main'
                }
            }
            environment {
                NEXT_VERSION = getNextSemanticVersion()
            }
            steps {
                sh '''#! /usr/bin/env bash
                    set -xeo pipefail
                    echo git tag ...
                    ls -al
                    git tag
                    git config --local user.name jenkins-release[bot]
                    git config --local user.email jenkins-release-bot@lpsolutions.com
                    echo "Next git version (used as tag): ${NEXT_VERSION}"
                    version=${NEXT_VERSION}
                    major_version=$(cut -d'.' -f1 <<<"${version}")
                    minor_version=$(cut -d'.' -f2 <<<"${version}")
                    patch_version=$(cut -d'.' -f3 <<<"${version}")
                    git push origin :${major_version} || true
                    git push origin :${major_version}.${minor_version} || true
                    git push origin :${major_version}.${minor_version}.${patch_version} || true
                    git tag -d ${major_version} || true
                    git tag -d ${major_version}.${minor_version} || true
                    git tag -d ${major_version}.${minor_version}.${patch_version} || true
                    git tag -a ${major_version} -m "Release ${major_version}"
                    git tag -a ${major_version}.${minor_version} -m "Release ${major_version}.${minor_version}"
                    git tag -a ${major_version}.${minor_version}.${patch_version} -m "Release ${major_version}.${minor_version}.${patch_version}"
                    git tag
                    git push origin ${major_version}
                    git push origin ${major_version}.${minor_version}
                    git push origin ${major_version}.${minor_version}.${patch_version}
                    echo ... git tag
               '''
            }
        }
    }

    post {
        success {
            echo 'Build successful! Celebrate with the team.'
        }

        failure {
            echo 'Build failed! Notify the team.'
        }

        always {
            echo 'Save artifacts'
            archiveArtifacts artifacts: '.artifacts/**', allowEmptyArchive: true
        }
    }
}
