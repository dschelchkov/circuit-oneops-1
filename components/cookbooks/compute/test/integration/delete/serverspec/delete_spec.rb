CIRCUIT_PATH     = '/opt/oneops/inductor/circuit-oneops-1'.freeze
COOKBOOKS_PATH   = "#{CIRCUIT_PATH}/components/cookbooks".freeze
AZURE_TESTS_PATH = "#{COOKBOOKS_PATH}/azure/test/integration/delete/serverspec/tests".freeze

require "#{CIRCUIT_PATH}/components/spec_helper.rb"
require "#{COOKBOOKS_PATH}/azure_base/test/integration/spec_utils"

provider = SpecUtils.new($node).get_provider

case provider
  when /azure/
    require "#{COOKBOOKS_PATH}/azure_base/test/integration/azure_spec_utils"
    Dir.glob("#{AZURE_TESTS_PATH}/*.rb").each {|tst| require tst}
  when /openstack/
    require "#{COOKBOOKS_PATH}/compute/test/integration/delete/serverspec/openstack.rb"
  else
    puts "No tests for provider: #{provider}"
end

