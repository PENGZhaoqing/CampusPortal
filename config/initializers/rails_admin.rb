require Rails.root.join('lib', 'rails_admin', 'access.rb').to_s
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::Access)

RailsAdmin.config do |config|

  # config.main_app_name = ["Cool app", "BackOffice"]
  # or something more dynamic
  config.main_app_name = Proc.new { |controller| ["Portal Gate", "#{controller.params[:action].try(:titleize)}"] }

  # config.authorize_with :cancan, AdminAbility

  config.included_models = ['User','Resource','Access','Cooperator','Relationship', 'Doorkeeper::Application','Doorkeeper::AccessGrant','Doorkeeper::AccessToken']

  # config.model ['Relationship'] do
  #   navigation_label 'Association'
  # end
  # config.navigation_static_links = {
  #     'Google' => 'http://www.google.com'
  # }
  # config.navigation_static_label = "My Links"

  # == Authenticate ==
  config.authorize_with do
    if current_admin.nil?
      redirect_to main_app.root_url(login_role:'admin') , flash: {:warning => 'please login as admin first'}
    end
  end

  config.current_user_method(&:current_admin)

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  config.audit_with :paper_trail, 'Cooperator', 'PaperTrail::Version' # PaperTrail >= 3.0.0
  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    # root actions
    dashboard                     # mandatory
    # collection actions
    index                         # mandatory
    new
    export
    history_index
    bulk_delete
    # member actions
    show
    edit
    delete
    history_show
    show_in_app
    access
  end
end
