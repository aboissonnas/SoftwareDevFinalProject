;

$(document).ready(function() {

    $('#submitSpell').click(function() {

        $.post('/newSpell', {sname: $('#spell_name').val(), lv: $('#spell_level').val(), desc: $('#spell_text').val(),
        role: $('#role_spell').val()}, function(data) {

            $('#spellError').append(data)

        });


    });

});