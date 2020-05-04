defmodule Scandoc.Documents do
  @moduledoc """
  The Documents context.
  """

  import Ecto.Query, warn: false
  alias Scandoc.Repo

  alias Scandoc.Documents.Document

  @doc """
  Returns the list of documents.

  ## Examples

      iex> list_documents()
      [%Document{}, ...]

  """
  def list_documents do
    Repo.all(Document)
  end

  @doc """
  Gets a single document.

  Raises `Ecto.NoResultsError` if the Document does not exist.

  ## Examples

      iex> get_document!(123)
      %Document{}

      iex> get_document!(456)
      ** (Ecto.NoResultsError)

  """
  def get_document!(id), do: Repo.get!(Document, id)

  @doc """
  Creates a document.

  ## Examples

      iex> create_document(%{field: value})
      {:ok, %Document{}}

      iex> create_document(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_document(attrs \\ %{}) do
    %Document{}
    |> Document.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a document.

  ## Examples

      iex> update_document(document, %{field: new_value})
      {:ok, %Document{}}

      iex> update_document(document, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_document(%Document{} = document, attrs) do
    document
    |> Document.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a document.

  ## Examples

      iex> delete_document(document)
      {:ok, %Document{}}

      iex> delete_document(document)
      {:error, %Ecto.Changeset{}}

  """
  def delete_document(%Document{} = document) do
    Repo.delete(document)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking document changes.

  ## Examples

      iex> change_document(document)
      %Ecto.Changeset{data: %Document{}}

  """
  def change_document(%Document{} = document, attrs \\ %{}) do
    Document.changeset(document, attrs)
  end

  alias Scandoc.Documents.Doctype

  @doc """
  Returns the list of doctypes.

  ## Examples

      iex> list_doctypes()
      [%Doctype{}, ...]

  """
  def list_doctypes do
    Repo.all(Doctype)
  end

  @doc """
  Gets a single doctype.

  Raises `Ecto.NoResultsError` if the Doctype does not exist.

  ## Examples

      iex> get_doctype!(123)
      %Doctype{}

      iex> get_doctype!(456)
      ** (Ecto.NoResultsError)

  """
  def get_doctype!(id), do: Repo.get!(Doctype, id)

  @doc """
  Creates a doctype.

  ## Examples

      iex> create_doctype(%{field: value})
      {:ok, %Doctype{}}

      iex> create_doctype(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_doctype(attrs \\ %{}) do
    %Doctype{}
    |> Doctype.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a doctype.

  ## Examples

      iex> update_doctype(doctype, %{field: new_value})
      {:ok, %Doctype{}}

      iex> update_doctype(doctype, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_doctype(%Doctype{} = doctype, attrs) do
    doctype
    |> Doctype.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a doctype.

  ## Examples

      iex> delete_doctype(doctype)
      {:ok, %Doctype{}}

      iex> delete_doctype(doctype)
      {:error, %Ecto.Changeset{}}

  """
  def delete_doctype(%Doctype{} = doctype) do
    Repo.delete(doctype)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking doctype changes.

  ## Examples

      iex> change_doctype(doctype)
      %Ecto.Changeset{data: %Doctype{}}

  """
  def change_doctype(%Doctype{} = doctype, attrs \\ %{}) do
    Doctype.changeset(doctype, attrs)
  end
end
