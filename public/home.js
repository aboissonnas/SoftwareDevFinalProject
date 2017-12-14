;

$(document).ready(function() {

    $('#generate').click(function() {
        console.log('Encounter being generated...')

        partyNum = $('#party-number').val();
        partyLevel = $('#party-level').val();
        difficulty = $('#diff').val();
        totalXP = calculatePlayerXP(partyNum, partyLevel, difficulty);

        $('#encounter').empty(); // we only wanna empty it out if it's being clicked again
        monsterXP = 0;

        console.log($('#environments').val());
            $.post('/', {environment: $('#environments').val(), maxXP: totalXP}, function(data){
                //while(monsterXP < totalXP - (partyLevel * 50)){

                console.log(data);
                console.log(data[0]);
                console.log(data[1]);
                
                $.each(data, function( key, val ) {
                
                
                });

               // }


            });
       
    });

});

// THIS ONLY WORKS FOR PARTIES THAT HAVE ALL THE SAME LEVEL OF PLAYERS.
// If functionality for different player levels is implemented, change this function.
function calculatePlayerXP(number, level, difficulty)
{
    xpArray = [25,50,75,100,
        50,100,150,200,
        75,150,225,400,
        125,250,375,500,
        250,500,750,1100,
        300,600,900,1400,
        350,750,1100,1700,
        450,900,1400,2100,
        550,1100,1600,2400,
        600,1200,1900,2800,
        800,1600,2400,3600,
        1000,2000,3000,4500,
        1100,2200,3400,5100,
        1250,2500,3800,5700,
        1400,2800,4300,6400,
        1600,3200,4800,7200,
        2000,3900,5900,8800,
        2100,4200,6300,9500,
        2400,4900,7300,10900,
        2800,5700,8500,12700];

        singleXP = xpArray[((level - 1) * 4) + (difficulty - 1)];
        // Simply multiplying by 4 puts the xp threshold at the easy threshold for next level.
        // Thus, subtract 1 to get to the appropriate level's easy difficulty. Then subtract 1 from difficulty
        // (array starts at 0) and add it to get the appropriate xp.

        totalXP = singleXP * number;
        console.log(singleXP);
        console.log(totalXP);
        return totalXP;
    
};