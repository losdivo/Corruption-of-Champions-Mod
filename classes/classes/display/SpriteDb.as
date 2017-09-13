/**
 * Coded by aimozg on 28.05.2017.
 */
package classes.display {
import classes.GlobalFlags.kFLAGS;
import classes.GlobalFlags.kGAMECLASS;

import flash.display.Bitmap;
import flash.display.BitmapData;

public class SpriteDb {
	private static function get is8bit():Boolean {
		return kGAMECLASS.flags[kFLAGS.SPRITE_STYLE] === 1;
	}

	[Embed(source="../../../res/sprites/akbal.png")]
	public static var s_akbal_16bit:Class;
	[Embed(source="../../../res/sprites8bit/akbal-old.png")]
	public static var s_akbal_8bit:Class;
	public static function get s_akbal(): Class {
		return is8bit ? s_akbal_8bit : s_akbal_16bit;
	}
	[Embed(source="../../../res/sprites/amarok.png")]
	public static var s_amarok_16bit:Class;
	[Embed(source="../../../res/sprites8bit/amarok-old.png")]
	public static var s_amarok_8bit:Class;
	public static function get s_amarok(): Class {
		return is8bit ? s_amarok_8bit : s_amarok_16bit;
	}
	[Embed(source="../../../res/sprites/amily.png")]
	public static var s_amily_16bit:Class;
	[Embed(source="../../../res/sprites8bit/amily-old.png")]
	public static var s_amily_8bit:Class;
	public static function get s_amily(): Class {
		return is8bit ? s_amily_8bit : s_amily_16bit;
	}
	[Embed(source="../../../res/sprites/amily_defurr.png")]
	public static var s_amily_defurr_16bit:Class;
	[Embed(source="../../../res/sprites8bit/amily-human-old.png")]
	public static var s_amily_defurr_8bit:Class;
	public static function get s_amily_defurr(): Class {
		return is8bit ? s_amily_defurr_8bit : s_amily_defurr_16bit;
	}
	[Embed(source="../../../res/sprites/anemone.png")]
	public static var s_anemone_16bit:Class;
	[Embed(source="../../../res/sprites8bit/anemone-old.png")]
	public static var s_anemone_8bit:Class;
	public static function get s_anemone(): Class {
		return is8bit ? s_anemone_8bit : s_anemone_16bit;
	}
	[Embed(source="../../../res/sprites/arian.png")]
	public static var s_arian_16bit:Class;
	[Embed(source="../../../res/sprites8bit/arian-old.png")]
	public static var s_arian_8bit:Class;
	public static function get s_arian(): Class {
		return is8bit ? s_arian_8bit : s_arian_16bit;
	}
	[Embed(source="../../../res/sprites8bit/assmole-old.png")]
	public static var s_assmole_8bit:Class;
	public static function get s_assmole(): Class {
		return s_assmole_8bit;
	}
	[Embed(source="../../../res/sprites/basilisk.png")]
	public static var s_basilisk_16bit:Class;
	[Embed(source="../../../res/sprites8bit/basilisk-old.png")]
	public static var s_basilisk_8bit:Class;
	public static function get s_basilisk(): Class {
		return is8bit ? s_basilisk_8bit : s_basilisk_16bit;
	}
	[Embed(source="../../../res/sprites/bee girl.png")]
	public static var s_bee_girl_16bit:Class;
	[Embed(source="../../../res/sprites8bit/beegirl-old.png")]
	public static var s_bee_girl_8bit:Class;
	public static function get s_bee_girl(): Class {
		return is8bit ? s_bee_girl_8bit : s_bee_girl_16bit;
	}
	[Embed(source="../../../res/sprites/ceraph.png")]
	public static var s_ceraph_16bit:Class;
	[Embed(source="../../../res/sprites8bit/ceraph-old.png")]
	public static var s_ceraph_8bit:Class;
	public static function get s_ceraph(): Class {
		return is8bit ? s_ceraph_8bit : s_ceraph_16bit;
	}
	[Embed(source="../../../res/sprites/ceraphClothed.png")]
	public static var s_ceraphClothed_16bit:Class;
	public static function get s_ceraphClothed(): Class {
		return is8bit ? null : s_ceraphClothed_16bit;
	}
	[Embed(source="../../../res/sprites/ceraphGoblin.png")]
	public static var s_ceraphGoblin_16bit:Class;
	public static function get s_ceraphGoblin(): Class {
		return is8bit ? null : s_ceraphGoblin_16bit;
	}
	[Embed(source="../../../res/sprites/cerulean succubus.png")]
	public static var s_cerulean_succubus_16bit:Class;
	[Embed(source="../../../res/sprites8bit/cerulean-succubus-old.png")]
	public static var s_cerulean_succubus_8bit:Class;
	public static function get s_cerulean_succubus(): Class {
		return is8bit ? s_cerulean_succubus_8bit : s_cerulean_succubus_16bit;
	}
	[Embed(source="../../../res/sprites/chameleon.png")]
	public static var s_chameleon_16bit:Class;
	public static function get s_chameleon(): Class {
		return is8bit ? null : s_chameleon_16bit;
	}
	[Embed(source="../../../res/sprites/chickenHarpy.png")]
	public static var s_chickenHarpy_16bit:Class;
	public static function get s_chickenHarpy(): Class {
		return is8bit ? null : s_chickenHarpy_16bit;
	}
	[Embed(source="../../../res/sprites/chillySmith.png")]
	public static var s_chillySmith_16bit:Class;
	[Embed(source="../../../res/sprites8bit/chillySmith-old.png")]
	public static var s_chillySmith_8bit:Class;
	public static function get s_chillySmith(): Class {
		return is8bit ? s_chillySmith_8bit : s_chillySmith_16bit;
	}
	[Embed(source="../../../res/sprites/christmas elf.png")]
	public static var s_christmas_elf_16bit:Class;
	[Embed(source="../../../res/sprites8bit/xmas-elf-old.png")]
	public static var s_christmas_elf_8bit:Class;
	public static function get s_christmas_elf(): Class {
		return is8bit ? s_christmas_elf_8bit : s_christmas_elf_16bit;
	}
	[Embed(source="../../../res/sprites/cinnabar.png")]
	public static var s_cinnabar_16bit:Class;
	public static function get s_cinnabar(): Class {
		return is8bit ? null : s_cinnabar_16bit;
	}
	[Embed(source="../../../res/sprites/cloaked dominika.png")]
	public static var s_cloaked_dominika_16bit:Class;
	[Embed(source="../../../res/sprites8bit/dominika-old.png")]
	public static var s_cloaked_dominika_8bit:Class;
	public static function get s_cloaked_dominika(): Class {
		return is8bit ? s_cloaked_dominika_8bit : s_cloaked_dominika_16bit;
	}
	[Embed(source="../../../res/sprites/club gnoll.png")]
	public static var s_club_gnoll_16bit:Class;
	[Embed(source="../../../res/sprites8bit/gnoll-old.png")]
	public static var s_club_gnoll_8bit:Class;
	public static function get s_club_gnoll(): Class {
		return is8bit ? s_club_gnoll_8bit : s_club_gnoll_16bit;
	}
	[Embed(source="../../../res/sprites/corruptedGlade.png")]
	public static var s_corruptedGlade_16bit:Class;
	public static function get s_corruptedGlade(): Class {
		return is8bit ? null : s_corruptedGlade_16bit;
	}
	[Embed(source="../../../res/sprites/cotton.png")]
	public static var s_cotton_16bit:Class;
	[Embed(source="../../../res/sprites8bit/cotton-old.png")]
	public static var s_cotton_8bit:Class;
	public static function get s_cotton(): Class {
		return is8bit ? s_cotton_8bit : s_cotton_16bit;
	}
	[Embed(source="../../../res/sprites/cumwitch.png")]
	public static var s_cumwitch_16bit:Class;
	[Embed(source="../../../res/sprites8bit/cumwitch-old.png")]
	public static var s_cumwitch_8bit:Class;
	public static function get s_cumWitch(): Class {
		return is8bit ? s_cumwitch_8bit : s_cumwitch_16bit;
	}
	[Embed(source="../../../res/sprites/dickworms.png")]
	public static var s_dickworms_16bit:Class;
	[Embed(source="../../../res/sprites8bit/worms-old.png")]
	public static var s_dickworms_8bit:Class;
	public static function get s_dickworms(): Class {
		return is8bit ? s_dickworms_8bit : s_dickworms_16bit;
	}
	[Embed(source="../../../res/sprites/drider.png")]
	public static var s_drider_16bit:Class;
	[Embed(source="../../../res/sprites8bit/drider-old.png")]
	public static var s_drider_8bit:Class;
	public static function get s_drider(): Class {
		return is8bit ? s_drider_8bit : s_drider_16bit;
	}
	[Embed(source="../../../res/sprites/easter bunneh.png")]
	public static var s_easter_bunneh_16bit:Class;
	[Embed(source="../../../res/sprites8bit/bunnygirl-old.png")]
	public static var s_easter_bunneh_8bit:Class;
	public static function get s_easter_bunneh(): Class {
		return is8bit ? s_easter_bunneh_8bit : s_easter_bunneh_16bit;
	}
	[Embed(source="../../../res/sprites/edryn.png")]
	public static var s_edryn_16bit:Class;
	[Embed(source="../../../res/sprites8bit/edryn-old.png")]
	public static var s_edryn_8bit:Class;
	public static function get s_edryn(): Class {
		return is8bit ? s_edryn_8bit : s_edryn_16bit;
	}
	[Embed(source="../../../res/sprites/exgartuan.png")]
	public static var s_exgartuan_16bit:Class;
	[Embed(source="../../../res/sprites8bit/exgartuan-old.png")]
	public static var s_exgartuan_8bit:Class;
	public static function get s_exgartuan(): Class {
		return is8bit ? s_exgartuan_8bit : s_exgartuan_16bit;
	}
	[Embed(source="../../../res/sprites/factory omnibus.png")]
	public static var s_factory_omnibus_16bit:Class;
	[Embed(source="../../../res/sprites8bit/omnibus-overseer-old.png")]
	public static var s_factory_omnibus_8bit:Class;
	public static function get s_factory_omnibus(): Class {
		return is8bit ? s_factory_omnibus_8bit : s_factory_omnibus_16bit;
	}
	[Embed(source="../../../res/sprites/faerie.png")]
	public static var s_faerie_16bit:Class;
	[Embed(source="../../../res/sprites8bit/faerie-old.png")]
	public static var s_faerie_8bit:Class;
	public static function get s_faerie(): Class {
		return is8bit ? s_faerie_8bit : s_faerie_16bit;
	}
	[Embed(source="../../../res/sprites/fenimp.png")]
	public static var s_fenimp_16bit:Class;
	[Embed(source="../../../res/sprites8bit/fenimp-old.png")]
	public static var s_fenimp_8bit:Class;
	public static function get s_fenimp(): Class {
		return is8bit ? s_fenimp_8bit : s_fenimp_16bit;
	}
	[Embed(source="../../../res/sprites/fetish cultist.png")]
	public static var s_fetish_cultist_16bit:Class;
	[Embed(source="../../../res/sprites8bit/fetish-cultist-old.png")]
	public static var s_fetish_cultist_8bit:Class;
	public static function get s_fetish_cultist(): Class {
		return is8bit ? s_fetish_cultist_8bit : s_fetish_cultist_16bit;
	}
	[Embed(source="../../../res/sprites/fetish zealot.png")]
	public static var s_fetish_zealot_16bit:Class;
	[Embed(source="../../../res/sprites8bit/fetish-zealot-old.png")]
	public static var s_fetish_zealot_8bit:Class;
	public static function get s_fetish_zealot(): Class {
		return is8bit ? s_fetish_zealot_8bit : s_fetish_zealot_16bit;
	}
	[Embed(source="../../../res/sprites8bit/shouldra-normal-old.png")]
	public static var s_ghostGirl_8bit:Class;
	public static function get s_ghostGirl(): Class {
		return s_ghostGirl_8bit;
	}
	[Embed(source="../../../res/sprites8bit/shouldra-ghost-old.png")]
	public static var s_ghostGirl2_8bit:Class;
	public static function get s_ghostGirl2(): Class {
		return s_ghostGirl2_8bit;
	}
	[Embed(source="../../../res/sprites/giacomo.png")]
	public static var s_giacomo_16bit:Class;
	[Embed(source="../../../res/sprites8bit/giacomo-old.png")]
	public static var s_giacomo_8bit:Class;
	public static function get s_giacomo(): Class {
		return is8bit ? s_giacomo_8bit : s_giacomo_16bit;
	}
	[Embed(source="../../../res/sprites/goblin.png")]
	public static var s_goblin_16bit:Class;
	[Embed(source="../../../res/sprites8bit/goblin-old.png")]
	public static var s_goblin_8bit:Class;
	public static function get s_goblin(): Class {
		return is8bit ? s_goblin_8bit : s_goblin_16bit;
	}
	[Embed(source="../../../res/sprites/priscilla.png")]
	public static var s_priscilla_16bit:Class;
	[Embed(source="../../../res/sprites8bit/priscilla-old.png")]
	public static var s_priscilla_8bit:Class;
	public static function get s_priscilla(): Class {
		return is8bit ? s_priscilla_8bit : s_priscilla_16bit;
	}
	[Embed(source="../../../res/sprites/goblinShaman.png")]
	public static var s_goblinShaman_16bit:Class;
	[Embed(source="../../../res/sprites8bit/goblinShaman-old.png")]
	public static var s_goblinShaman_8bit:Class;
	public static function get s_goblinShaman(): Class {
		return is8bit ? s_goblinShaman_8bit : s_goblinShaman_16bit;
	}
	[Embed(source="../../../res/sprites/goblinWarrior.png")]
	public static var s_goblinWarrior_16bit:Class;
	[Embed(source="../../../res/sprites8bit/goblinWarrior-old.png")]
	public static var s_goblinWarrior_8bit:Class;
	public static function get s_goblinWarrior(): Class {
		return is8bit ? s_goblinWarrior_8bit : s_goblinWarrior_16bit;

	}
	[Embed(source="../../../res/sprites/googirlsprite.png")]
	public static var s_googirlsprite_16bit:Class;
	[Embed(source="../../../res/sprites8bit/googirl-old.png")]
	public static var s_googirlsprite_8bit:Class;
	public static function get s_googirlsprite(): Class {
		return is8bit ? s_googirlsprite_8bit : s_googirlsprite_16bit;
	}
	[Embed(source="../../../res/sprites/green slime.png")]
	public static var s_green_slime_16bit:Class;
	[Embed(source="../../../res/sprites8bit/slime-old.png")]
	public static var s_green_slime_8bit:Class;
	public static function get s_green_slime(): Class {
		return is8bit ? s_green_slime_8bit : s_green_slime_16bit;
	}
	[Embed(source="../../../res/sprites/harpy.png")]
	public static var s_harpy_16bit:Class;
	[Embed(source="../../../res/sprites8bit/harpy-old.png")]
	public static var s_harpy_8bit:Class;
	public static function get s_harpy(): Class {
		return is8bit ? s_harpy_8bit : s_harpy_16bit;
	}
	[Embed(source="../../../res/sprites/hel-sprite.png")]
	public static var s_hel_sprite_16bit:Class;
	[Embed(source="../../../res/sprites8bit/hel-sprite-old.png")]
	public static var s_hel_sprite_8bit:Class;
	public static function get s_hel_sprite(): Class {
		return is8bit ? s_hel_sprite_8bit : s_hel_sprite_16bit;
	}
	[Embed(source="../../../res/sprites/hel-sprite_BB.png")]
	public static var s_hel_sprite_BB_16bit:Class;
	[Embed(source="../../../res/sprites8bit/hel-sprite_BB-old.png")]
	public static var s_hel_sprite_BB_8bit:Class;
	public static function get s_hel_sprite_BB(): Class {
		return is8bit ? s_hel_sprite_BB_8bit : s_hel_sprite_BB_16bit;
	}
	[Embed(source="../../../res/sprites/hel-sprite_PF.png")]
	public static var s_hel_sprite_PF_16bit:Class;
	[Embed(source="../../../res/sprites8bit/hel-sprite_PF-old.png")]
	public static var s_hel_sprite_PF_8bit:Class;
	public static function get s_hel_sprite_PF(): Class {
		return is8bit ? s_hel_sprite_PF_8bit : s_hel_sprite_PF_16bit;
	}
	[Embed(source="../../../res/sprites/hel-sprite_BB_PF.png")]
	public static var s_hel_sprite_BB_PF_16bit:Class;
	[Embed(source="../../../res/sprites8bit/hel-sprite_BB_PF-old.png")]
	public static var s_hel_sprite_BB_PF_8bit:Class;
	public static function get s_hel_sprite_BB_PF(): Class {
		return is8bit ? s_hel_sprite_BB_PF_8bit : s_hel_sprite_BB_PF_16bit;
	}
	[Embed(source="../../../res/sprites/hellhound.png")]
	public static var s_hellhound_16bit:Class;
	[Embed(source="../../../res/sprites8bit/hellhound-old.png")]
	public static var s_hellhound_8bit:Class;
	public static function get s_hellhound(): Class {
		return is8bit ? s_hellhound_8bit : s_hellhound_16bit;
	}
	[Embed(source="../../../res/sprites/ifris.png")]
	public static var s_ifris_16bit:Class;
	[Embed(source="../../../res/sprites8bit/ifris-old.png")]
	public static var s_ifris_8bit:Class;
	public static function get s_ifris(): Class {
		return is8bit ? s_ifris_8bit : s_ifris_16bit;
	}
	[Embed(source="../../../res/sprites/imp.png")]
	public static var s_imp_16bit:Class;
	[Embed(source="../../../res/sprites8bit/imp-old.png")]
	public static var s_imp_8bit:Class;
	public static function get s_imp(): Class {
		return is8bit ? s_imp_8bit : s_imp_16bit;
	}
	[Embed(source="../../../res/sprites/impOverlord.png")]
	public static var s_impOverlord_16bit:Class;
	[Embed(source="../../../res/sprites8bit/impOverlord-old.png")]
	public static var s_impOverlord_8bit:Class;
	public static function get s_impOverlord(): Class {
		return is8bit ? s_impOverlord_8bit : s_impOverlord_16bit;
	}
	[Embed(source="../../../res/sprites/impWarlord.png")]
	public static var s_impWarlord_16bit:Class;
	[Embed(source="../../../res/sprites8bit/impWarlord-old.png")]
	public static var s_impWarlord_8bit:Class;
	public static function get s_impWarlord(): Class {
		return is8bit ? s_impWarlord_8bit : s_impWarlord_16bit;
	}
	[Embed(source="../../../res/sprites/incubus mechanic.png")]
	public static var s_incubus_mechanic_16bit:Class;
	[Embed(source="../../../res/sprites8bit/incubus-mechanic-old.png")]
	public static var s_incubus_mechanic_8bit:Class;
	public static function get s_incubus_mechanic(): Class {
		return is8bit ? s_incubus_mechanic_8bit : s_incubus_mechanic_16bit;
	}
	[Embed(source="../../../res/sprites/isabella.png")]
	public static var s_isabella_16bit:Class;
	[Embed(source="../../../res/sprites8bit/isabella-old.png")]
	public static var s_isabella_8bit:Class;
	public static function get s_isabella(): Class {
		return is8bit ? s_isabella_8bit : s_isabella_16bit;
	}
	[Embed(source="../../../res/sprites/izma.png")]
	public static var s_izma_16bit:Class;
	[Embed(source="../../../res/sprites8bit/izma-old.png")]
	public static var s_izma_8bit:Class;
	public static function get s_izma(): Class {
		return is8bit ? s_izma_8bit : s_izma_16bit;
	}
	[Embed(source="../../../res/sprites/jasun.png")]
	public static var s_jasun_16bit:Class;
	[Embed(source="../../../res/sprites8bit/jasun-old.png")]
	public static var s_jasun_8bit:Class;
	public static function get s_jasun(): Class {
		return is8bit ? s_jasun_8bit : s_jasun_16bit;
	}
	[Embed(source="../../../res/sprites/jojo.png")]
	public static var s_jojo_16bit:Class;
	[Embed(source="../../../res/sprites8bit/jojo-old.png")]
	public static var s_jojo_8bit:Class;
	public static function get s_jojo(): Class {
		return is8bit ? s_jojo_8bit : s_jojo_16bit;
	}
	[Embed(source="../../../res/sprites/jojoTentacle.png")]
	public static var s_jojoTentacle_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/jojoTentacle-old.png")]
	public static var s_jojoTentacle_8bit:Class;
	public static function get s_jojoTentacle(): Class {
		return is8bit ? s_jojoTentacle_8bit : s_jojoTentacle_16bit;
	}
	[Embed(source="../../../res/sprites/katherine-vagrant.png")]
	public static var s_katherine_vagrant_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/katherine-vagrant-old.png")]
	public static var s_katherine_vagrant_8bit:Class;
	public static function get s_katherine_vagrant(): Class {
		return is8bit ? s_katherine_vagrant_8bit : s_katherine_vagrant_16bit;
	}
	[Embed(source="../../../res/sprites/kelt.png")]
	public static var s_kelt_16bit:Class;
	[Embed(source="../../../res/sprites8bit/kelt-old.png")]
	public static var s_kelt_8bit:Class;
	public static function get s_kelt(): Class {
		return is8bit ? s_kelt_8bit : s_kelt_16bit;
	}
	[Embed(source="../../../res/sprites/kida.png")]
	public static var s_kida_16bit:Class;
	[Embed(source="../../../res/sprites8bit/kida-old.png")]
	public static var s_kida_8bit:Class;
	public static function get s_kida(): Class {
		return is8bit ? s_kida_8bit : s_kida_16bit;
	}
	[Embed(source="../../../res/sprites/kiha.png")]
	public static var s_kiha_16bit:Class;
	[Embed(source="../../../res/sprites8bit/kiha-old.png")]
	public static var s_kiha_8bit:Class;
	public static function get s_kiha(): Class {
		return is8bit ? s_kiha_8bit : s_kiha_16bit;
	}
	[Embed(source="../../../res/sprites/kitsune_black.png")]
	public static var s_kitsune_black_16bit:Class;
	[Embed(source="../../../res/sprites8bit/kitsune_black-old.png")]
	public static var s_kitsune_black_8bit:Class;
	public static function get s_kitsune_black(): Class {
		return is8bit ? s_kitsune_black_8bit : s_kitsune_black_16bit;
	}
	[Embed(source="../../../res/sprites/kitsune_blonde.png")]
	public static var s_kitsune_blonde_16bit:Class;
	[Embed(source="../../../res/sprites8bit/kitsune_blonde-old.png")]
	public static var s_kitsune_blonde_8bit:Class;
	public static function get s_kitsune_blonde(): Class {
		return is8bit ? s_kitsune_blonde_8bit : s_kitsune_blonde_16bit;
	}
	[Embed(source="../../../res/sprites/kitsune_red.png")]
	public static var s_kitsune_red_16bit:Class;
	[Embed(source="../../../res/sprites8bit/kitsune_red-old.png")]
	public static var s_kitsune_red_8bit:Class;
	public static function get s_kitsune_red(): Class {
		return is8bit ? s_kitsune_red_8bit : s_kitsune_red_16bit;
	}
	[Embed(source="../../../res/sprites/lilium.png")]
	public static var s_lilium_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/lilium-old.png")]
	public static var s_lilium_8bit:Class;
	public static function get s_lilium(): Class {
		return is8bit ? s_lilium_8bit : s_lilium_16bit;
	}
	[Embed(source="../../../res/sprites/lottie.png")]
	public static var s_lottie_16bit:Class;
	[Embed(source="../../../res/sprites8bit/lottie-old.png")]
	public static var s_lottie_8bit:Class;
	public static function get s_lottie(): Class {
		return is8bit ? s_lottie_8bit : s_lottie_16bit;
	}
	[Embed(source="../../../res/sprites/lumi.png")]
	public static var s_lumi_16bit:Class;
	[Embed(source="../../../res/sprites8bit/lumi-old.png")]
	public static var s_lumi_8bit:Class;
	public static function get s_lumi(): Class {
		return is8bit ? s_lumi_8bit : s_lumi_16bit;
	}
	[Embed(source="../../../res/sprites/lynette.png")]
	public static var s_lynette_16bit:Class;
	[Embed(source="../../../res/sprites8bit/lynnette-old.png")]
	public static var s_lynette_8bit:Class;
	public static function get s_lynette(): Class {
		return is8bit ? s_lynette_8bit : s_lynette_16bit;
	}
	[Embed(source="../../../res/sprites/maddie.png")]
	public static var s_maddie_16bit:Class;
	[Embed(source="../../../res/sprites8bit/maddie-old.png")]
	public static var s_maddie_8bit:Class;
	public static function get s_maddie(): Class {
		return is8bit ? s_maddie_8bit : s_maddie_16bit;
	}
	[Embed(source="../../../res/sprites/marae.png")]
	public static var s_marae_16bit:Class;
	[Embed(source="../../../res/sprites8bit/marae-old.png")]
	public static var s_marae_8bit:Class;
	public static function get s_marae(): Class {
		return is8bit ? s_marae_8bit : s_marae_16bit;
	}
	[Embed(source="../../../res/sprites/marble.png")]
	public static var s_marble_16bit:Class;
	[Embed(source="../../../res/sprites8bit/marble-old.png")]
	public static var s_marble_8bit:Class;
	public static function get s_marble(): Class {
		return is8bit ? s_marble_8bit : s_marble_16bit;
	}
	[Embed(source="../../../res/sprites/markus and lucia.png")]
	public static var s_markus_and_lucia_16bit:Class;
	[Embed(source="../../../res/sprites8bit/marcus-and-lucia-old.png")]
	public static var s_markus_and_lucia_8bit:Class;
	public static function get s_markus_and_lucia(): Class {
		return is8bit ? s_markus_and_lucia_8bit : s_markus_and_lucia_16bit;
	}
	[Embed(source="../../../res/sprites8bit/melinda-old.png")]
	public static var s_melinda_8bit:Class;
	public static function get s_melinda(): Class {
		return s_melinda_8bit;
	}
	[Embed(source="../../../res/sprites/minerva.png")]
	public static var s_minerva_16bit:Class;
	[Embed(source="../../../res/sprites8bit/minerva-old.png")]
	public static var s_minerva_8bit:Class;
	public static function get s_minerva(): Class {
		return is8bit ? s_minerva_8bit : s_minerva_16bit;
	}
	[Embed(source="../../../res/sprites/minerva-corrupt.png")]
	public static var s_minerva_corrupt_16bit:Class;
	[Embed(source="../../../res/sprites8bit/minerva-corrupt-old.png")]
	public static var s_minerva_corrupt_8bit:Class;
	public static function get s_minerva_corrupt(): Class {
		return is8bit ? s_minerva_corrupt_8bit : s_minerva_corrupt_16bit;
	}
	[Embed(source="../../../res/sprites/minerva-pure.png")]
	public static var s_minerva_pure_16bit:Class;
	[Embed(source="../../../res/sprites8bit/minerva-pure-old.png")]
	public static var s_minerva_pure_8bit:Class;
	public static function get s_minerva_pure(): Class {
		return is8bit ? s_minerva_pure_8bit : s_minerva_pure_16bit;
	}
	[Embed(source="../../../res/sprites/minotaur.png")]
	public static var s_minotaur_16bit:Class;
	[Embed(source="../../../res/sprites8bit/minotaur-old.png")]
	public static var s_minotaur_8bit:Class;
	public static function get s_minotaur(): Class {
		return is8bit ? s_minotaur_8bit : s_minotaur_16bit;
	}
	[Embed(source="../../../res/sprites/minotaurSons.png")]
	public static var s_minotaurSons_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/minotaurSons-old.png")]
	public static var s_minotaurSons_8bit:Class;
	public static function get s_minotaurSons(): Class {
		return is8bit ? s_minotaurSons_8bit : s_minotaurSons_16bit;
	}
	[Embed(source="../../../res/sprites/mrsCoffee.png")]
	public static var s_mrsCoffee_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/mrsCoffee-old.png")]
	public static var s_mrsCoffee_8bit:Class;
	public static function get s_mrsCoffee(): Class {
		return is8bit ? s_mrsCoffee_8bit : s_mrsCoffee_16bit;
	}
	[Embed(source="../../../res/sprites/naga.png")]
	public static var s_naga_16bit:Class;
	[Embed(source="../../../res/sprites8bit/naga-old.png")]
	public static var s_naga_8bit:Class;
	public static function get s_naga(): Class {
		return is8bit ? s_naga_8bit : s_naga_16bit;
	}
	[Embed(source="../../../res/sprites/oasis demons.png")]
	public static var s_oasis_demons_16bit:Class;
	[Embed(source="../../../res/sprites8bit/oasis-demons-old.png")]
	public static var s_oasis_demons_8bit:Class;
	public static function get s_oasis_demons(): Class {
		return is8bit ? s_oasis_demons_8bit : s_oasis_demons_16bit;
	}
	[Embed(source="../../../res/sprites/oswald.png")]
	public static var s_oswald_16bit:Class;
	[Embed(source="../../../res/sprites8bit/oswald-old.png")]
	public static var s_oswald_8bit:Class;
	public static function get s_oswald(): Class {
		return is8bit ? s_oswald_8bit : s_oswald_16bit;
	}
	[Embed(source="../../../res/sprites/poisontail.png")]
	public static var s_poisontail_16bit:Class;
	[Embed(source="../../../res/sprites8bit/roxanne-old.png")]
	public static var s_poisontail_8bit:Class;
	public static function get s_poisontail(): Class {
		return is8bit ? s_poisontail_8bit : s_poisontail_16bit;
	}
	[Embed(source="../../../res/sprites8bit/raphael-old.png")]
	public static var s_raphael_8bit:Class;
	public static function get s_raphael(): Class {
		return s_raphael_8bit;
	}
	[Embed(source="../../../res/sprites/rathazul.png")]
	public static var s_rathazul_16bit:Class;
	[Embed(source="../../../res/sprites8bit/rathazul-old.png")]
	public static var s_rathazul_8bit:Class;
	public static function get s_rathazul(): Class {
		return is8bit ? s_rathazul_8bit : s_rathazul_16bit;
	}
	[Embed(source="../../../res/sprites/rogar.png")]
	public static var s_rogar_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/rogar-old.png")]
	public static var s_rogar_8bit:Class;
	public static function get s_rogar(): Class {
		return is8bit ? s_rogar_8bit : s_rogar_16bit;
	}
	[Embed(source="../../../res/sprites/rubi_hornless.png")]
	public static var s_rubi_hornless_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/rubi_hornless-old.png")]
	public static var s_rubi_hornless_8bit:Class;
	public static function get s_rubi_hornless(): Class {
		return is8bit ? s_rubi_hornless_8bit : s_rubi_hornless_16bit;
	}
	[Embed(source="../../../res/sprites/rubi_horns.png")]
	public static var s_rubi_horns_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/rubi_horns-old.png")]
	public static var s_rubi_horns_8bit:Class;
	public static function get s_rubi_horns(): Class {
		return is8bit ? s_rubi_horns_8bit : s_rubi_horns_16bit;
	}
	[Embed(source="../../../res/sprites/sandtrap.png")]
	public static var s_sandtrap_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/sandtrap-old.png")]
	public static var s_sandtrap_8bit:Class;
	public static function get s_sandtrap(): Class {
		return is8bit ? s_sandtrap_8bit : s_sandtrap_16bit;
	}
	[Embed(source="../../../res/sprites/sandwich.png")]
	public static var s_sandwich_16bit:Class;
	[Embed(source="../../../res/sprites8bit/sand-witch-old.png")]
	public static var s_sandwich_8bit:Class;
	public static function get s_sandwich(): Class {
		return is8bit ? s_sandwich_8bit : s_sandwich_16bit;
	}
	[Embed(source="../../../res/sprites/satyr.png")]
	public static var s_satyr_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/satyr-old.png")]
	public static var s_satyr_8bit:Class;
	public static function get s_satyr(): Class {
		return is8bit ? s_satyr_8bit : s_satyr_16bit;
	}
	[Embed(source="../../../res/sprites/scylla.png")]
	public static var s_scylla_16bit:Class;
	[Embed(source="../../../res/sprites8bit/scylla-old.png")]
	public static var s_scylla_8bit:Class;
	public static function get s_scylla(): Class {
		return is8bit ? s_scylla_8bit : s_scylla_16bit;
	}
	[Embed(source="../../../res/sprites/scyllaAndBear.png")]
	public static var s_scyllaAndBear_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/scyllaAndBear-old.png")]
	public static var s_scyllaAndBear_8bit:Class;
	public static function get s_scyllaAndBear(): Class {
		return is8bit ? s_scyllaAndBear_8bit : s_scyllaAndBear_16bit;
	}
	[Embed(source="../../../res/sprites/sean.png")]
	public static var s_sean_16bit:Class;
	[Embed(source="../../../res/sprites8bit/sean-old.png")]
	public static var s_sean_8bit:Class;
	public static function get s_sean(): Class {
		return is8bit ? s_sean_8bit : s_sean_16bit;
	}
	[Embed(source="../../../res/sprites/sharkgirl.png")]
	public static var s_sharkgirl_16bit:Class;
	[Embed(source="../../../res/sprites8bit/sharkgirl-old.png")]
	public static var s_sharkgirl_8bit:Class;
	public static function get s_sharkgirl(): Class {
		return is8bit ? s_sharkgirl_8bit : s_sharkgirl_16bit;
	}
	[Embed(source="../../../res/sprites/sophie.png")]
	public static var s_sophie_16bit:Class;
	[Embed(source="../../../res/sprites8bit/sophie-old.png")]
	public static var s_sophie_8bit:Class;
	public static function get s_sophie(): Class {
		return is8bit ? s_sophie_8bit : s_sophie_16bit;
	}
	[Embed(source="../../../res/sprites/sophieBimbo.png")]
	public static var s_sophieBimbo_16bit:Class;
	[Embed(source="../../../res/sprites8bit/sophieBimbo-old.png")]
	public static var s_sophieBimbo_8bit:Class;
	public static function get s_sophieBimbo(): Class {
		return is8bit ? s_sophieBimbo_8bit : s_sophieBimbo_16bit;
	}
	[Embed(source="../../../res/sprites/spear gnoll.png")]
	public static var s_spear_gnoll_16bit:Class;
	[Embed(source="../../../res/sprites8bit/gnoll-spearthrower-old.png")]
	public static var s_spear_gnoll_8bit:Class;
	public static function get s_spear_gnoll(): Class {
		return is8bit ? s_spear_gnoll_8bit : s_spear_gnoll_16bit;
	}
	[Embed(source="../../../res/sprites/spidergirl.png")]
	public static var s_spidergirl_16bit:Class;
	[Embed(source="../../../res/sprites8bit/spider-morph-f-old.png")]
	public static var s_spidergirl_8bit:Class;
	public static function get s_spidergirl(): Class {
		return is8bit ? s_spidergirl_8bit : s_spidergirl_16bit;
	}
	[Embed(source="../../../res/sprites/spiderguy.png")]
	public static var s_spiderguy_16bit:Class;
	[Embed(source="../../../res/sprites8bit/spider-morph-m-old.png")]
	public static var s_spiderguy_8bit:Class;
	public static function get s_spiderguy(): Class {
		return is8bit ? s_spiderguy_8bit : s_spiderguy_16bit;
	}
	[Embed(source="../../../res/sprites/stuckSatyr.png")]
	public static var s_stuckSatyr_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/stuckSatyr-old.png")]
	public static var s_stuckSatyr_8bit:Class;
	public static function get s_stuckSatyr(): Class {
		return is8bit ? s_stuckSatyr_8bit : s_stuckSatyr_16bit;
	}
	[Embed(source="../../../res/sprites/succubus secretary.png")]
	public static var s_succubus_secretary_16bit:Class;
	[Embed(source="../../../res/sprites8bit/secretarial-succubus-old.png")]
	public static var s_succubus_secretary_8bit:Class;
	public static function get s_succubus_secretary(): Class {
		return is8bit ? s_succubus_secretary_8bit : s_succubus_secretary_16bit;
	}
	[Embed(source="../../../res/sprites/tamani's daughters.png")]
	public static var s_tamani_s_daughters_16bit:Class;
	[Embed(source="../../../res/sprites8bit/tamanis-daughters-old.png")]
	public static var s_tamani_s_daughters_8bit:Class;
	public static function get s_tamani_s_daughters(): Class {
		return is8bit ? s_tamani_s_daughters_8bit : s_tamani_s_daughters_16bit;
	}
	[Embed(source="../../../res/sprites/tamani.png")]
	public static var s_tamani_16bit:Class;
	[Embed(source="../../../res/sprites8bit/tamani-old.png")]
	public static var s_tamani_8bit:Class;
	public static function get s_tamani(): Class {
		return is8bit ? s_tamani_8bit : s_tamani_16bit;
	}
	[Embed(source="../../../res/sprites/tentacleMonster.png")]
	public static var s_tentacleMonster_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/tentacleMonster-old.png")]
	public static var s_tentacleMonster_8bit:Class;
	public static function get s_tentacleMonster(): Class {
		return is8bit ? s_tentacleMonster_8bit : s_tentacleMonster_16bit;
	}
	[Embed(source="../../../res/sprites/uncloaked dominika.png")]
	public static var s_uncloaked_dominika_16bit:Class;
	[Embed(source="../../../res/sprites8bit/dominika-old.png")]
	public static var s_uncloaked_dominika_8bit:Class;
	public static function get s_uncloaked_dominika(): Class {
		return is8bit ? s_uncloaked_dominika_8bit : s_uncloaked_dominika_16bit;
	}
	[Embed(source="../../../res/sprites/urta.png")]
	public static var s_urta_16bit:Class;
	[Embed(source="../../../res/sprites8bit/urta-old.png")]
	public static var s_urta_8bit:Class;
	public static function get s_urta(): Class {
		return is8bit ? s_urta_8bit : s_urta_16bit;
	}
	[Embed(source="../../../res/sprites/urtaDrunk.png")]
	public static var s_urtaDrunk_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/urtaDrunk-old.png")]
	public static var s_urtaDrunk_8bit:Class;
	public static function get s_urtaDrunk(): Class {
		return is8bit ? s_urtaDrunk_8bit : s_urtaDrunk_16bit;
	}
	[Embed(source="../../../res/sprites/vagrant cats.png")]
	public static var s_vagrant_cats_16bit:Class;
	[Embed(source="../../../res/sprites8bit/vagrant-cats-old.png")]
	public static var s_vagrant_cats_8bit:Class;
	public static function get s_vagrant_cats(): Class {
		return is8bit ? s_vagrant_cats_8bit : s_vagrant_cats_16bit;
	}
	[Embed(source="../../../res/sprites/vala.png")]
	public static var s_vala_16bit:Class;
	[Embed(source="../../../res/sprites8bit/vala-old.png")]
	public static var s_vala_8bit:Class;
	public static function get s_vala(): Class {
		return is8bit ? s_vala_8bit : s_vala_16bit;
	}
	[Embed(source="../../../res/sprites/valaSlave.png")]
	public static var s_valaSlave_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/valaSlave-old.png")]
	public static var s_valaSlave_8bit:Class;
	public static function get s_valaSlave(): Class {
		return is8bit ? s_valaSlave_8bit : s_valaSlave_16bit;
	}
	[Embed(source="../../../res/sprites/valeria.png")]
	public static var s_valeria_16bit:Class;
	[Embed(source="../../../res/sprites8bit/valeria-old.png")]
	public static var s_valeria_8bit:Class;
	public static function get s_valeria(): Class {
		return is8bit ? s_valeria_8bit : s_valeria_16bit;
	}
	[Embed(source="../../../res/sprites/venus.png")]
	public static var s_venus_16bit:Class;
//	[Embed(source="../../../res/sprites8bit/venus-old.png")]
	public static var s_venus_8bit:Class;
	public static function get s_venus(): Class {
		return is8bit ? s_venus_8bit : s_venus_16bit;
	}
	[Embed(source="../../../res/sprites/victoria.png")]
	public static var s_victoria_16bit:Class;
	[Embed(source="../../../res/sprites8bit/victoria-old.png")]
	public static var s_victoria_8bit:Class;
	public static function get s_victoria(): Class {
		return is8bit ? s_victoria_8bit : s_victoria_16bit;
	}
//	[Embed(source="../../../res/sprites/whitney.png")]
//	public static var s_whitney_16bit:Class;
	[Embed(source="../../../res/sprites8bit/whitney-old.png")]
	public static var s_whitney_8bit:Class;
	public static function get s_whitney(): Class {
		return is8bit ? s_whitney_8bit : null;
	}
	[Embed(source="../../../res/sprites/weaponsmith.png")]
	public static var s_weaponsmith_16bit:Class;
	[Embed(source="../../../res/sprites8bit/weaponsmith-old.png")]
	public static var s_weaponsmith_8bit:Class;
	public static function get s_weaponsmith(): Class {
		return is8bit ? s_weaponsmith_8bit : s_weaponsmith_16bit;
	}
	[Embed(source="../../../res/sprites/yara.png")]
	public static var s_yara_16bit:Class;
	[Embed(source="../../../res/sprites8bit/yara-old.png")]
	public static var s_yara_8bit:Class;
	public static function get s_yara(): Class {
		return is8bit ? s_yara_8bit : s_yara_16bit;
	}
	[Embed(source="../../../res/sprites/yvonne.png")]
	public static var s_yvonne_16bit:Class;
	[Embed(source="../../../res/sprites8bit/yvonne-old.png")]
	public static var s_yvonne_8bit:Class;
	public static function get s_yvonne(): Class {
		return is8bit ? s_yvonne_8bit : s_yvonne_16bit;
	}

	public static function bitmapData(clazz:Class):BitmapData {
		if (!clazz) return null;
		var e:Object = new clazz();
		if (!(e is Bitmap)) return null;
		return (e as Bitmap).bitmapData;
	}
  
	public function SpriteDb() {
	}
}
}
