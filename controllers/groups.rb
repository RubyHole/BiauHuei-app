# frozen_string_literal: true

require 'roda'

module BiauHuei
  # Web controller for BiauHuei API
  class App < Roda
    route('groups') do |routing|
      routing.is do
        # GET /groups
        routing.get do
          if @current_user.logged_in?
            groups = GetGroups.new(App.config).call(@current_user)
            
            view :groups,
                 locals: { current_user: @current_user, groups: groups }
          else
            routing.redirect '/auth/login'
          end
        end
      end
      
      routing.on do
        routing.is Integer do |group_id|
          # GET /groups/[group_id]
          routing.get do
            if @current_user.logged_in?
              group = GetGroup.new(App.config).call(@current_user, group_id)
              
              view :group,
                   locals: { current_user: @current_user, group: group }
            else
              routing.redirect 'auth/login'
            end
          end
        end
      end
    end
  end
end
