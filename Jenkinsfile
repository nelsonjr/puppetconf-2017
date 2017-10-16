pipeline {
  agent any
  stages {
    stage('Puppet Setup') {
      steps {
        sh '''# RPM setup
if ! rpm -q puppetlabs-release-pc1; then
  rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
fi'''
        sh '''# Puppet setup
if ! rpm -q puppet-agent; then
  yum install -y puppet-agent
fi
'''
      }
    }
    stage('Bolt Setup') {
      steps {
        sh '$PUPPET resource package gcc-c++ ensure=present'
        sh '''$PUPPET resource package bolt \\
  ensure=present provider=puppet_gem'''
      }
    }
    stage('Infrastructure Up') {
      steps {
        sh '''declare -r puppet=/opt/puppetlabs/bin/puppet

$puppet module list

export'''
      }
    }
  }
  environment {
    MODULES = 'google-cloud'
  }
}