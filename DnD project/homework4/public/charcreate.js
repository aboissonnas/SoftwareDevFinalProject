;

$(document).ready(function() {
    $('#charCreateButton').click(function() {
        // field ids are where you get the params that get passed to the backend
        console.log('character being created');

        chosenSpells = fsearch();

        $.post('/newCharacter', {char: $('#character_name').val(), play: $('#player_name').val(),
            bio: $('#bio').val(), race: $('#race_choices').val(), therole: $('#role_choices').val(),
             spells: chosenSpells, strength: $('#strength').val(), dex: $('#dex').val(),
             con: $('#con').val(), wis: $('#wis').val(), intel: $('#intel').val(), cha: $('#cha').val()}, function(data) {
            

        });

    });

    function fsearch() {
        //var narr    =   new Array();
       // narr=nearby;//a global arr
        var checked_vals = [];
        $('#spells input:checkbox:checked').each(function(index) {
            checked_vals.push($(this).attr('id'));
        });
        return checked_vals;
    }

    $('#abilRoll').click(function() {
        console.log('grabbing 24 d6.....');
        total = 0;

        total += roll4D6();
        total += roll4D6();
        total += roll4D6();
        total += roll4D6();
        total += roll4D6();
        total += roll4D6();

        $('#total').empty(); // you thought you'd get free points?????

        $('.abil').val(''); // clear out all the current nums
        
        $('#total').append(total);


    });

    $('.abil').on('focusin', function(){
        console.log("Saving value " + $(this).val());
        $(this).data('val', $(this).val());
    });

    $('.abil').on('change', function() {
        //this is SO broken but I have to wait to fix it

        lostPoints = $(this).val();
        origVal = $(this).data('val');

        theTotal = parseInt($('#total').text(), 10);
        console.log(theTotal);
        console.log(origVal);
        console.log(lostPoints);

        if(lostPoints >= origVal){
            theTotal -= (lostPoints - origVal);
        }
        else if(lostPoints < origVal)
        {
            theTotal += (origVal - lostPoints);
        }

        if(theTotal <= 0)
        {
            theTotal = 0;
        }
        $('#total').empty();

        $('#total').append(theTotal);

    });

    //$('race_flavor').trigger('change');
    $('#race_choices').on('change', function() {
        $.post('/newCharacter', {rid: $('#race_choices').val()}, function(data) {
    
            $('#race_flavor').empty(); // empty out whatever previous thing was in the div
    
            $('#race_flavor').append(data);
        });
    });

    $('#role_choices').on('change', function() {
        $.post('/newCharacter', {roid: $('#role_choices').val()}, function(data) {
            $('#role_flavor').empty(); // empty out whatever previous thing was in the div
        
            $('#role_flavor').append(data);
        });
    
    
      
    });

    $('#showSpells').click(function() {
        console.log('fetching spells');
        $.post('/newCharacter', {role: $('#role_choices').val()}, function(data){
            $('#spells').empty();

            $('#spells').append("Select your spells. If there are no spells to select, then your class is nonmagical and you can move on.<br/> <br/>");

            $.each(data, function( key, val ) {
                //append the name
                $("#spells").append("<div class='spell_list'>");
                $("#spells").append("<input type = checkbox class = 'spell_box' id = '" + val.sid + "'>")
                $("#spells").append(val.name + "<br/>");
                $("#spells").append("Level: " + val.level + "<br/>");
                $("#spells").append("Description: " + val.flavortext);
                //newline
                $("#spells").append("</br>");
                $("#spells").append("</div>");


            });

            $('.spell_box :checkbox').on('click', function () {
                var $cs = $(this).closest('.spell_box').find(':checkbox:checked');
                if ($cs.length > 1) {
                    this.checked = false;
                }
            });



        });



    });


});

function rollD6() {

    return Math.floor(Math.random() * 6) + 1;

};

function roll4D6() {
    retVal = 0;
    d1 = rollD6();
    d2 = rollD6();
    d3 = rollD6();
    d4 = rollD6();

    die = [d1, d2, d3, d4];
    die.sort(); // for larger numbers this is a problem but these are all single digit

    retVal += die[1];
    retVal += die[2];
    retVal += die[3]; //we took away the smallest digit

    console.log(retVal);
    return retVal;


}

