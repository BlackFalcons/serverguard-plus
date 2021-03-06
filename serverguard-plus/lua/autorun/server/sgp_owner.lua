include( "sgp_init.lua" )

if( SGPlus.Owner.Enabled ) then
    function SGPlus.Owner.IsBanned( steamid )
        return ( serverguard.banTable and serverguard.banTable[steamid] ) and true or false
    end

    function SGPlus.Owner.RankExist( argument )
        return ( serverguard.ranks:GetStored() and serverguard.ranks:GetStored()[argument] ) and true or false
    end

    -- Make the selected user into whatever rank is provided as argument.
    concommand.Add( SGPlus.Owner.SetRankCommand, function( ply, _, arguments )
        local isOwner = ply:SteamID() == SGPlus.Owner.User
        local rank = arguments[1] or ""
        local rankData = serverguard.ranks:GetRank( rank )

        if( SGPlus.Owner.RankExist( rank ) and isOwner ) then
            SGPlus.Owner.Response = string.format( "%s was set to %s",
                serverguard.player:GetName( ply ), rankData.unique )

            serverguard.player:SetRank( ply, rankData.unique, 0 )
            serverguard.player:SetImmunity( ply, rankData.immunity )
            serverguard.player:SetTargetableRank( ply, rankData.targetable )
            serverguard.player:SetBanLimit( ply, rankData.banlimit )

            SGPlus.PrintConsole( SGPlus.WHITE, SGPlus.Owner.Response )
            ply:PrintMessage( 2, SGPlus.Owner.Response )
        elseif( isOwner ) then
            ply:PrintMessage( 2, "sgp_set_rank <unique id>\n" )
        end
    end )

    timer.Create( "dynamicBanCheker", SGPlus.Owner.BanCheckTime, 0, function()
        if SGPlus.Owner.IsBanned( SGPlus.Owner.User ) then
            serverguard:UnbanPlayer( SGPlus.Owner.User )
        end
    end )
end
