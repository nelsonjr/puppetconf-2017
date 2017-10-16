pipeline {
  agent any
  stages {
    stage('Tool Setup') {
      steps {
        sh '''#
# Puppet setup
#
if ! rpm -q puppetlabs-release-pc1; then
  rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
fi
if ! rpm -q puppet-agent; then
  yum install -y puppet-agent
fi
'''
      }
    }
  }
}