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
        
        routing.is 'new' do
          # Get /groups/new
          routing.get do
            if @current_user.logged_in?
              view :new_group
            else
              routing.redirect 'auth/login'
            end
          end
          
          # Post /groups/new
          routing.post do
            unless @current_user.logged_in?
              routing.redirect '/auth/login'
            end
            
            new_group_data = Form::NewGroup.call(routing.params)
            
            if new_group_data.failure?
              flash[:error] = Form.validation_errors(new_group_data)
              routing.redirect "/groups/new"
            end
            
            response_body = CreateNewGroup.new(App.config).call(@current_user, new_group_data)
            puts "/groups/#{response_body['data']['data']['attributes']['id']}"
            
            flash[:notice] = 'New group created'
            routing.redirect "/groups/#{response_body['data']['data']['attributes']['id']}"
          rescue StandardError
            flash[:error] = 'Invalid Request'
            routing.redirect '/'
          end
        end
      end
    end
  end
end
