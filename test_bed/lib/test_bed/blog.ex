defmodule TestBed.Blog do
  use Ash.Domain

  resources do
    resource TestBed.Blog.Post do
      # Define an interface for calling resource actions.
      define :create_post, action: :create
      define :list_posts, action: :read
      define :update_post, action: :update
      define :destroy_post, action: :destroy
      define :get_post, args: [:id], action: :by_id
    end

    resource TestBed.Blog.Author do
      # Define an interface for calling resource actions.
      define :create_author, action: :create
      define :list_authors, action: :read
      define :update_author, action: :update
      define :destroy_author, action: :destroy
      define :get_author, args: [:id], action: :by_id
    end

  end
end
