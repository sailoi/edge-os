defmodule EdgeOsCloud.Device do
  @moduledoc """
  The Device context.
  """

  import Ecto.Query, warn: false
  alias EdgeOsCloud.Repo

  alias EdgeOsCloud.Device.Edge
  alias EdgeOsCloud.Device.EdgeSession
  alias EdgeOsCloud.Accounts.Team

  @doc """
  Returns the list of edges.

  ## Examples

      iex> list_edges()
      [%Edge{}, ...]

  """
  def list_edges do
    Repo.all(Edge)
  end

  @doc """
  Returns the list of active edges from user account.

  ## Examples

      iex> list_active_account_edges(user.id)
      [%Edge{}, ...]

  """
  def list_active_account_edges(user_id) do
    query = from e in Edge,
          join: t in Team,
          on: ^user_id in t.admins or ^user_id in t.members,
          where: e.deleted == false and t.deleted == false,
          preload: [team: t],
          order_by: [desc: t.inserted_at],
          select: e

    Repo.all(query)
  end

  @doc """
  Gets a single edge.

  Raises `Ecto.NoResultsError` if the Edge does not exist.

  ## Examples

      iex> get_edge!(123)
      %Edge{}

      iex> get_edge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_edge!(id), do: Repo.get!(Edge, id)

  def get_with_uuid!(uuid) do
    query = from e in Edge,
          where: e.uuid == ^uuid,
          select: e

    [edge] = Repo.all(query)
    edge
  end

  def get_edge_session!(id), do: Repo.get!(EdgeSession, id)

  @doc """
  Creates a edge.

  ## Examples

      iex> create_edge(%{field: value})
      {:ok, %Edge{}}

      iex> create_edge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_edge(attrs \\ %{}) do
    %Edge{}
    |> Edge.changeset(attrs)
    |> Repo.insert()
  end

  def create_edge_session(attrs \\ %{}) do
    %EdgeSession{}
    |> EdgeSession.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a edge.

  ## Examples

      iex> update_edge(edge, %{field: new_value})
      {:ok, %Edge{}}

      iex> update_edge(edge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_edge(%Edge{} = edge, attrs) do
    edge
    |> Edge.changeset(attrs)
    |> Repo.update()
  end

  def update_edge_session(%EdgeSession{} = session, attrs) do
    session
    |> EdgeSession.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a edge.

  ## Examples

      iex> delete_edge(edge)
      {:ok, %Edge{}}

      iex> delete_edge(edge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_edge(%Edge{} = edge) do
    update_edge(edge, %{deleted: true})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking edge changes.

  ## Examples

      iex> change_edge(edge)
      %Ecto.Changeset{data: %Edge{}}

  """
  def change_edge(%Edge{} = edge, attrs \\ %{}) do
    Edge.changeset(edge, attrs)
  end
end
