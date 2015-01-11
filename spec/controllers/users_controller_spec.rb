require 'spec_helper'

describe UsersController do
  render_views
  fixtures :users
  it "should render show template on show call when logged in" do
    session[:user_id] = users(:sam).id
    get 'show', :id=>users(:sam).id
    response.should render_template('show')
  end
end
