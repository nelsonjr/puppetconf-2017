class profile::myapp (
  $version,
) {

  include "profile::myapp::v${version}"

}
