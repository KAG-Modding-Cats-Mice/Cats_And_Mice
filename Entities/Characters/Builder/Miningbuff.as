#include "Knocked.as";

//f32 SOUND_DISTANCE = 256.0f;
const int MINING_FREQUENCY = 60 * 30;

void onInit( CBlob@ this )
{
	this.set_u32("last mining", 0 );
	this.set_bool("mining ready", true );
	this.set_u32("mining", 0);
	this.Sync("mining", true);

	this.addCommandID("mining");
}

void onTick( CBlob@ this ) 
{	
	if (this.get_u32("mining") > 6*30)
	{
		this.set_u32("mining", 6*30 - 5);
	}
	bool ready = this.get_bool("mining ready");
	const u32 gametime = getGameTime();
	CControls@ controls = getControls();
	
	if(ready) 
    {
		if (this !is null)
		{
			if (isClient() && this.isMyPlayer())
			{
				if (controls.isKeyJustPressed(KEY_KEY_R))
				{
					this.set_u32("last mining", gametime);
					this.set_bool("mining ready", false);
					this.SendCommand(this.getCommandID("mining"));
				}
			}
		}
	} else 
    {		
		u32 lastMining = this.get_u32("last mining");
		int diff = gametime - (lastMining + MINING_FREQUENCY);
		
		if(controls.isKeyJustPressed(KEY_KEY_R) && this.isMyPlayer())
		{
			Sound::Play("Entities/Characters/Sounds/NoAmmo.ogg");
		}

		if (diff > 0)
		{
			this.set_bool("mining ready", true );
			this.getSprite().PlaySound("/Cooldown1.ogg"); 
		}
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
    if (cmd == this.getCommandID("mining"))
    {
        Mining(this);
    }
}

void Mining(CBlob@ this) //check the anim and logic files too	
{	
	CSprite@ sprite = this.getSprite();
	Animation@ animation_strike = sprite.getAnimation("strike");
	Animation@ animation_chop = sprite.getAnimation("chop");
	for (int i = 0; i < 7*30; i++)
	{
		if (i < 6*30)
		{
			animation_strike.time = 1;
			animation_chop.time = 1;	
		} 
		else if (i > 6*30)
		{
			animation_strike.time = 2;	
			animation_chop.time = 2;
		} 
		else 
		{
			return;
		}
	}
	this.Sync("mining", true);
	
    //sound
	//CBlob@[] nearBlobs;
	//this.getMap().getBlobsInRadius( this.getPosition(), SOUND_DISTANCE, @nearBlobs );
	//this.getSprite().PlaySound("", 3.0f);
	
}