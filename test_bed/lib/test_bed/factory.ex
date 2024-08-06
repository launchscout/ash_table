defmodule TestBed.Factory do
  use Smokestack

  alias TestBed.Blog.Post

  factory Post do
    attribute :title, &Faker.Lorem.sentence/1
  end
end
