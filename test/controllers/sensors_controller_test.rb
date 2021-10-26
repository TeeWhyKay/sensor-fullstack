require 'test_helper'

class SensorsControllerTest < ActionDispatch::IntegrationTest
  test "should get main" do
    get sensors_main_url
    assert_response :success
  end

end
