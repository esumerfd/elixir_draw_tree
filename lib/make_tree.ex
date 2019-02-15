defmodule Tree do
  
  def make do
    branch_depth = Enum.random(8..10)
    tree = %{start: [250, 500], tree: %{stroke: 10, rotation: 180, length: 50} }
    
    tree(tree, branch_depth)
    |> render
  end

  def tree(tree = %{start: start, tree: branch}, branches_left) do
    %{start: start, tree: branch(tree, branch, branches_left)}
  end

  def branch(_, branch, 0), do: branch
  def branch(tree, branch, branches_left) do
    new_branch = Map.put(branch, :branches, 
      for _ <- 0..Enum.random(0..2) do
        branch(tree, create_branch(branch, branches_left), branches_left - 1)
      end 
    )

    #IO.puts("Rendering " <> Integer.to_string(branches_left))
    #render_tree(tree, new_branch)
    #:timer.sleep(5000);

    new_branch
  end

  def create_branch(%{stroke: stroke, length: length, rotation: rotation}, branches_left) do
    %{stroke: round(random_stroke(stroke)), 
      rotation: random_rotation(rotation, branches_left), 
      length: random_length(length)}
  end

  def random_stroke(stroke) do
    stroke * 0.8
  end

  def random_rotation(_, _) do
    arc = round(Enum.random(10..30))
    Enum.random(-arc..arc)
  end
  
  def random_length(length) do
    lower = length * 0.8
    upper = length * 1
    Enum.random(round(lower)..round(upper))
  end

  def render_tree(%{start: start, tree: _}, branch) do
    render(%{start: start, tree: branch})
  end

  def render(tree) do
    json = Jason.encode!(tree, pretty: true)
    File.write("../frac-tree/frac-tree.json", json)
  end
end
