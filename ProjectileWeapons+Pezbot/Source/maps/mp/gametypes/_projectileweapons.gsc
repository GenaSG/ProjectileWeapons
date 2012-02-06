init()
{
	self thread noBunny();
}
noBunny()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );
	
	self AllowJump(false);
}