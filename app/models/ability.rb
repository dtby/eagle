class Ability
  include CanCan::Ability

  def initialize(admin)
    if admin.grade == 'room'
      role_room
    else
      can :manage, :all
    end
  end

  def role_room
    can [:index, :edit, :update], Admin
    can [:index, :new, :create, :edit, :update, :destroy], User
    can [:index, :create], :report
    can [:index, :new, :create, :edit, :show, :update], :area
    can [:index, :edit, :show, :update, :refresh], Room
    can [:index, :new, :create, :edit, :update, :destroy], Attachment
  end
end
