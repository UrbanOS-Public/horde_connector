library(
    identifier: 'pipeline-lib@4.3.0',
    retriever: modernSCM([$class: 'GitSCMSource',
                          remote: 'https://github.com/SmartColumbusOS/pipeline-lib',
                          credentialsId: 'jenkins-github-user'])
)

properties([
    pipelineTriggers([scos.dailyBuildTrigger()]),
])

node ('master') {
    ansiColor('xterm') {
        scos.doCheckoutStage()

        stage ('Build') {
            docker.build("scos/horde-connector:${env.GIT_COMMIT_HASH}")
        }
    }
}