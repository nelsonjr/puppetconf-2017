pipeline {
  agent any
  stages {
    stage('Puppet Setup') {
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
    stage('Bolt Setup') {
      steps {
        sh '''declare -r puppet=/opt/puppetlabs/bin/puppet

# Bolt requires to build gem in C++
$puppet resource package gcc-c++ ensure=present

$puppet resource package bolt \\
  ensure=present provider=puppet_gem'''
      }
    }
    stage('Infrastructure Up') {
      steps {
        sh '''declare -r puppet=/opt/puppetlabs/bin/puppet

$puppet module list
'''
      }
    }
  }
}