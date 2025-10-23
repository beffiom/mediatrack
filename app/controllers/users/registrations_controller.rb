class Users::RegistrationsController < Devise::RegistrationsController
  def update_password
  end

  def change_password
    if current_user.valid_password?(params[:current_password])
      if current_user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        bypass_sign_in(current_user)
        redirect_to edit_user_registration_path, notice: "password updated successfully"
      else
        flash.now[:alert] = current_user.errors.full_messages.to_sentence
        render :update_password
      end
    else
      flash.now[:alert] = "current password is incorrect"
      render :update_password
    end
  end

  def update_api_key
    current_user.tmdb_api_key = params[:tmdb_api_key]
    if current_user.save
      redirect_to edit_user_registration_path
    else
      @api_key_error = current_user.errors[:tmdb_api_key].first
      render :edit
    end
  end

  def destroy
    if current_user.valid_password?(params[:current_password])
      resource.destroy
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message! :notice, :destroyed
      yield resource if block_given?
      respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
    else
      redirect_to edit_user_registration_path, alert: "incorrect password"
    end
  end
end
