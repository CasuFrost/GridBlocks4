using Godot;
using System;

public partial class create_world_test : Node2D
{
	TileMap TileMapNode;
	CharacterBody2D player;
	bool can = false;
	bool disCam = false;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		 if(can){

		 TileMapNode = (TileMap)GetNode("TileMap");
		 player = (CharacterBody2D)GetNode("PlayerTest");
		 if(disCam){
			player.Set("camEn",false);
		 }
		 
		 Vector2 tile = (Vector2)TileMapNode.Call("local_to_map",player.Get("tmp"));
		 TileMapNode.Call("erase_cell",0,tile);
		 int xSize=500;
		 int ySize=200;
		 Vector2 tilePos = new Vector2(0,0);
		 Vector2 tile2;
		 Vector2[] myNum = {new Vector2(0,0)};
		 for (int i = 0; i < ySize; i++) 
		{
  			for(int j = 0;j<xSize;j++){
				tilePos.X=j*16;
				tilePos.Y=i*16;// = Vector2(j*16,i*16);
				tile2 = (Vector2)TileMapNode.Call("local_to_map",tilePos);
				myNum[0]=tile2;
				TileMapNode.Call("set_cells_terrain_connect",0,myNum,0,5);
			}
		}
		 }
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
