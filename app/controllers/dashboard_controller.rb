class DashboardController < ApplicationController
   before_action :authenticate_user!
   before_action :ensure_admin
  def index
    # Total number of documents
    @total_docs = Ownerdoc.count

    # You don’t have a status column, so we just display counts
    @docs_by_type = Ownerdoc.group(:doc_type).count
    @recent_docs = Ownerdoc.order(created_at: :desc).limit(5)

    # Total owners and tenants if you want to show overall stats
    @total_owners = User.where(role: "owner").count
    @total_tenants = User.where(role: "tenant").count
  end
end
