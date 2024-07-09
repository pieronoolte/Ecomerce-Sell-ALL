require "test_helper"

class FetchCountryServiceTest < ActiveSupport::TestCase

    test 'it should return "CA" with a valid ip' do
        stub_request(:get, "http://ip-api.com/json/24.48.0.1").
        with(
          headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Host'=>'ip-api.com',
                'User-Agent'=>'Ruby'
          }).
        to_return(status: 200, body: {
            status: "success",
            countryCode: "CA"
    }.to_json, headers: {})
      assert_equal(FetchCountryService.new("24.48.0.1").perform, "ca")
    end

    test 'it should return "CA" with a invalid ip' do
        stub_request(:get, "http://ip-api.com/json/fakeip").
        with(
          headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Host'=>'ip-api.com',
                'User-Agent'=>'Ruby'
          }).
        to_return(status: 200, body: {
            status: "fail"
    }.to_json, headers: {})
      assert_nil(FetchCountryService.new("fakeip").perform, nil)
    end
  end
  