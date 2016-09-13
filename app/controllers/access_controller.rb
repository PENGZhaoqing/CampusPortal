class AccessController < ApplicationController
  include AccessHelper

  before_action :login_as_admin_or_cooperator
  before_action :set_access

  # node2=[1, 8, 5, 9, 1, 7, 4, 7, 3, 1, 9, 7, 2, 10, 9, 8, 10, 5, 2, 8, 8, 9, 4, 1, 5, 9, 4, 5, 9, 6, 3, 9, 4, 1, 3, 8, 6, 7, 9, 4, 4, 5, 6, 9, 8, 5, 3]
  # parent_id2= [1, 18, 15, 19, 181, 187, 184, 157, 153, 151, 159, 197, 192, 1910, 1819, 1818, 18110, 1875, 1872, 1878, 1848, 1849, 1844, 1841, 1575, 1579, 1574, 1535, 1539, 1536, 1513, 1519, 1514, 1591, 1593, 1598, 1596, 1977, 1979, 1974, 1924, 1925, 1926, 19109, 19108, 19105, 19103]

  def edit
    @parsed_array=PortalGate::Parser.path_parse(@access.node, @access.path)
  end

  def associate
    @user.applications<<@application
    @user.accesses.create!(node: [1], path: [1], app_id: @application.id)
    redirect_to users_path(@application, @user),
                flash: {success: 'user has been associated with this app '}
  end

  def disassociate
    @access.destroy
    @user.applications.delete(@application)
    redirect_to list_all_users_path(@application, @user),
                flash: {success: 'user has been disassociated with this app '}
  end

  def update
    node, path=reconstruct(access_params)
    if @access.update_attributes(node: node, path: path)
      flash='The changes has been updated'
      redirect_to edit_user_access_path(@user, @application), flash: {success: flash}
    else
      flash = 'Fail to update changes, please try it again '
      redirect_to edit_user_access_path(@user, @application), flash: {danger: flash}
    end
  end

  private

  def access_params
    params.require(:access).permit(:node, :path)
  end

  def login_as_admin_or_cooperator
    if !admin_logged_in? && !developer_logged_in?
        redirect_to root_url, flash: {danger: 'You have to login as admin or cooperator'}
    end
  end

  def set_access
    @user=User.find_by(id: params[:user_id])
    @application=Doorkeeper::Application.find_by(id: params[:id])
    @access=@user.accesses.find_by(app_id: params[:id])
  end

end
