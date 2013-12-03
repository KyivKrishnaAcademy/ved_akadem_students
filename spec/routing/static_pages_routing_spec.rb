require "spec_helper"

describe "routes for StaticPages" do
  it { expect(get: "/static_pages/home" ).to route_to("static_pages#home" ) }
  it { expect(get: "/static_pages/about").to route_to("static_pages#about") }
end
