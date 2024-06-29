defmodule TestBed.Repo.Migrations.AddAuthor do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:posts) do
      add :author_id, :uuid
    end

    create table(:authors, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
    end

    alter table(:posts) do
      modify :author_id,
             references(:authors,
               column: :id,
               name: "posts_author_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    alter table(:authors) do
      add :name, :text, null: false
    end
  end

  def down do
    alter table(:authors) do
      remove :name
    end

    drop constraint(:posts, "posts_author_id_fkey")

    alter table(:posts) do
      modify :author_id, :uuid
    end

    drop table(:authors)

    alter table(:posts) do
      remove :author_id
    end
  end
end