guideDetails = {
  animals: [{
      header: 'bird'
      subHeader: '<em>Aves</em> class'
      description: '''
        <p>All birds can be classified using this option. Birds have wings, feathers, and beaks; most are capable of flight. A wide variety of birds can be found throughout Africa.  Examples of birds seen on Chimp & See include guineafowl, ibis, hornbills, and rails.  Usually seen during the day or at dawn/dusk.</p>
      '''
      confusions: ['other (non-primate)']
      confusionsDetail: [':bat']
      exampleImages: ["./assets/guide/bird-1.jpg", "./assets/guide/bird-2.jpg", "./assets/guide/bird-3.jpg"]
    },
    {
      header: 'cattle'
      subHeader: '<em>Bos taurus</em>'
      description: '''
        <p>Domestic cattle (cows, bulls, and steers) can sometimes be seen in these videos. Cattle are large ungulates typically raised as livestock. Often horned, they can vary in color, but are most often brown, black, tan, and/or white. Branding may be visible on side/flank.  Usually seen during the day.</p>
      '''
      confusions: ['forest buffalo']
      exampleImages: ["./assets/guide/cattle-1.jpg"]
    },

    {
      header: 'chimpanzee'
      subHeader: '<em>Pan</em> genus'
      description: '''
        <p>This large primate, a close relative of humans, has no tail and is usually seen on the ground.  The hair is most often black, though it can appear grey or yellow-grey, especially on the lower back.  The face, ears, palms, and soles are hairless and skin color varies from peachy-pink to black.  They most often travel by knuckle-walking on all fours, and are occasionally seen in trees.  Males are slightly larger than females; infants have a white spot on rear.  Almost always seen during the day.</p>

        <p class="talk-link"><a href="http://talk.chimpandsee.org/#/boards/BCP0000001/discussions/DCP000015b" target="_blank">Chimp or gorilla?</a></p>
        <p class="talk-link"><a href="http://talk.chimpandsee.org/#/boards/BCP0000002/discussions/DCP0000bwy" target="_blank">Youth or adult?</a></p>
      '''
      confusions: ['gorilla', 'other (primate)', 'human']
      exampleImages: ["./assets/guide/chimp-1.jpg", "./assets/guide/chimp-2.jpg", "./assets/guide/chimp-3.jpg"]
    },

    {
      header: 'dark duiker'
      subHeader: '<em>Cephalophus</em> genus'
      description: '''
        <p>Use this option to mark any duikers that are dark grey, black, or dark brown in color.  Dark duikers include the yellow-backed duiker, a large duiker notable for a bright yellowish stripe on the back of a brown coat with a partially yellow muzzle, and the black duiker, which is medium-sized, solid black on the body, fading into red on the head, and with a white tail tip. Like other duikers, they have arched backs, stocky bodies and slender legs.  Yellow-backed duikers are more often seen at night, while black duikers are seen during the day or at dawn/dusk.</p>

        <p class="talk-link"><a href="http://talk.chimpandsee.org/#/boards/BCP000000e/discussions/DCP0000asr" target="_blank">Duiker Guide</a></p>
      '''
      confusions: ['large ungulate', 'small antelope']
      exampleImages: ["./assets/guide/dark-duiker-1.jpg", "./assets/guide/dark-duiker-2.jpg", "./assets/guide/dark-duiker-3.jpg"]
    },

    {
      header: 'elephant'
      subHeader: '<em>Loxodonta</em> genus'
      description: '<p>This massive, grey, thick-skinned animal is famous for its very large ears, long trunk, and ivory tusks. When not fully in frame, it can still be identified by its powerful, vertically positioned legs and its leathery, wrinkled skin. Seen both at night and during the day.</p>'
      exampleImages: ["./assets/guide/elephant-1.jpg", "./assets/guide/elephant-2.jpg", "./assets/guide/elephant-3.jpg"]
    },

    {
      header: 'forest buffalo'
      subHeader: '<em>Syncerus caffer nanus</em>'
      description: '''
        <p>Smaller (250-320 kg) subspecies of the African buffalo. Reddish-brown hide darkens to black around the face and lower legs, with a black dorsal stripe. Horns curl straight backwards in a C shape, with large, sometimes tufted ears. Solid, robust build with relatively short and thickset legs; typically carries head low.  More often seen at night, but sometimes active during the day.</p>
      '''
      confusions: ['cattle']
      exampleImages: ["./assets/guide/forest-buffalo-1.jpg", "./assets/guide/forest-buffalo-2.jpg", "./assets/guide/forest-buffalo-3.jpg"]
    },

    {
      header: 'giant forest hog'
      subHeader: '<em>Hylochoerus meinertzhageni</em>'
      description: '''
        <p>The largest species of wild pig. Most identifiable by its size, coat of very long black hairs (thinner in older hogs), and upward-curved tusks that are proportionally smaller than a warthog’s. Skin color is dark brown.  Males have large protruding swellings under each eye.  Almost always seen during the day or at dawn/dusk.</p>
      '''
      confusions: ['red river hog', 'warthog']
      exampleImages: ["./assets/guide/giant-forest-hog-1.jpg", "./assets/guide/giant-forest-hog-2.jpg"]
    },

    {
      header: 'gorilla'
      subHeader: '<em>Gorilla genus</em>'
      description: '''
        <p>Like chimpanzees, gorillas are apes, but much bigger and more powerfully built. Gorillas also have black skin and faces throughout their lives, while chimpanzees are born with pink skin.  Gorillas have black/brown coats, extremely muscular arms, and large heads.  Males are larger, have silver-colored backs, and large domed crests on top of their heads. Almost always seen during the day. Gorillas are not found at any sites in Region A (West Africa).</p>

        <p class="talk-link"><a href="http://talk.chimpandsee.org/#/boards/BCP0000001/discussions/DCP000015b" target="_blank">Chimp or gorilla?</a></p>
      '''
      confusions: ['chimpanzee']
      exampleImages: ["./assets/guide/gorilla-1.jpg", "./assets/guide/gorilla-2.jpg", "./assets/guide/gorilla-3.jpg"]
    },

    {
      header: 'hippopotamus'
      subHeader: '<em>Hippopotamus amphibius</em>'
      description:  '''
        <p>Large and round with short legs and smooth, shiny skin that appears dark grey to pink. Small ears and a massive, wide mouth. Short, thick tail is trimmed with black bristles.  Mostly seen at night.</p>
      '''
      exampleImages: ["./assets/guide/hippos-1.jpg", "./assets/guide/hippos-2.jpg", "./assets/guide/hippos-3.jpg"]
    },

    {
      header: 'human'
      subHeader: '<em>Homo sapiens</em>'
      description: '<p>Human beings may occasionally be seen in the videos: researchers, local residents, or even poachers. Mark any humans with this tag.  When the camera is being methodically adjusted by the field team, but they are not in view, you can mark human too.</p>'
      exampleImages: ["./assets/guide/humans-1.jpg", "./assets/guide/humans-2.jpg", "./assets/guide/humans-3.jpg"]
    },

    {
      header: 'hyena'
      subHeader: '<em>Hyaenidae</em> family'
      description:  '''
        <p>Looks dog-like. Broad head, with large pointed ears; body slopes dramatically from shoulder to hip. Two species in study range: spotted and striped. Spotted hyenas have speckled gray-red coats. Striped hyenas are slightly smaller, with dirty-gray, striped coats.</p>
      '''
      confusions: ['other (non-primate)']
      confusionsDetail: [':viverrid']
      exampleImages: ["./assets/guide/hyenas-1.jpg", "./assets/guide/hyenas-2.jpg", "./assets/guide/hyenas-3.jpg"]
    },

    {
      header: 'Jentink\'s duiker'
      subHeader: '<em>Cephalophus jentinki</em>'
      description: '''
        <p>Duiker with unique coloration: black head and shoulders, thin white band behind shoulders, and gray rest of body. Longer horns angling straight back from head. One of the largest species of duikers, with an extremely solid body. Almost always seen at night.</p>

        <p class="talk-link"><a href="http://talk.chimpandsee.org/#/boards/BCP000000e/discussions/DCP0000asr" target="_blank">Duiker Guide</a></p>
      '''
      confusions: ['large ungulate']
      exampleImages: ["./assets/guide/jentiks-duiker-1.jpg"]
      credit: "Credit: Brent Huffman - Ultimate Ungulate Images."
    },

    {
      header: 'large ungulate'
      subHeader: '<em>Ungulata</em> superorder'
      description: '''
        <p>Use this option to mark any large hooved mammal other than those with separate categories; for instance, sitatungas, bongos, okapi, roan antelope, etc.  Water chevrotains are medium-sized, but get marked in this category.  Some species are more likely to be seen during the day, and others at night.</p>
      '''
      confusions: ['duiker', 'small antelope']
      exampleImages: ["./assets/guide/large-ungulate-1.jpg", "./assets/guide/large-ungulate-2.jpg", "./assets/guide/large-ungulate-3.jpg"]
    },

    {
      header: 'leopard'
      subHeader: '<em>Panthera pardus</em>'
      description: '<p>Muscular golden big cat with black rosettes. Spotted face, no black lines, with small, round ears. Long, spotted tail has bright white fur underneath the tip, which is easy to see when they curl their tails upward. Melanistic variant has mostly (or fully) black coat. Seen both at night and during the day.</p>'
      exampleImages: ["./assets/guide/leopard-1.jpg", "./assets/guide/leopard-2.jpg", "./assets/guide/leopard-3.jpg"]
    },

    {
      header: 'lion'
      subHeader: '<em>Panthera leo</em>'
      description: '<p>Massive, muscular cats. They are tawny coloured with paler underparts; cubs show some spots, especially on their bellies and legs. They have a long tail with smooth fur and a dark tuft on its tip. Males have manes that get darker and thicker with age.</p>'
      exampleImages: ["./assets/guide/lion-1.jpg", "./assets/guide/lion-2.jpg", "./assets/guide/lion-3.jpg"]
    },

    {
      header: 'other (non-primate)'
      subHeader: null
      description: '''
        <p>Mark any animal that does not fall into the other categories as "other non-primate." This includes cat-like viverrids like the civet and genet (almost always seen at night), as well as honey badgers (night and day), hyrax (night and day), hares (night), and bats (night).  Hyrax can be distinguished from rodents by their lack of a tail.  Domestic animals other than cattle (e.g. dogs, goats, sheep) should be marked in this category as well. Please mark “Nothing here” for insects and fires, but feel free to tag them on the talk page!</p>
      '''
      confusions: ['small cat', 'rodent', 'bird']
      confusionsDetail: [' (for civets and genets)', ' (for hyrax and hares)', ' (for bats)']
      exampleImages: ["./assets/guide/other-1.jpg", "./assets/guide/other-2.jpg", "./assets/guide/other-3.jpg", "./assets/guide/other-4.jpg"]
    },

    {
      header: 'other (primate)'
      subHeader: '<em>Cercopithecidae</em> family and <em>Lorisoidea</em> superfamily'
      description: '''
        <p>Non-ape primates are different from apes in several ways. They typically are smaller, with tails, less broad chests, and less upright posture. African monkeys have non-prehensile tails, hind legs longer than forearms, and downward-pointing nostrils. Coloration varies between species.  Africa is also home to galagos (sometimes called bushbabies) and pottos, two kinds of small primitive primate.  Monkeys are frequently seen in groups and during the day or at dawn/dusk.  Galagos and pottos are usually seen alone and at night.</p>

        <p class="talk-link"><a href="http://talk.chimpandsee.org/#/boards/BCP000000e/discussions/DCP00007sb" target="_blank">Monkey Guide</a></p>
      '''
      confusions: ['chimpanzee', 'rodent']
      confusionsDetail: [null, ' (for galagos/pottos)']
      exampleImages: ["./assets/guide/small-primates-1.jpg", "./assets/guide/small-primates-2.jpg", "./assets/guide/small-primates-3.jpg"]
    },

    {
      header: 'pangolin'
      subHeader: '<em>Manis</em> genus'
      description: '<p>Also called “scaly anteater,” this unique creature’s body is covered from snout to long tail in overlapping earth-toned plates.  Multiple species of pangolin are native to Africa, ranging in size from around 2 kg to over 30 kg. Almost always seen at night.</p>'
      exampleImages: ["./assets/guide/pangolin-1.jpg", "./assets/guide/pangolin-2.jpg", "./assets/guide/pangolin-3.jpg"]
    },

    {
      header: 'porcupine'
      subHeader: '<em>Hystricidae</em> family'
      description: '''
        <p>Porcupines are short, rounded creatures covered from head to tail with long quills. Two species of porcupine are found in the study area: the crested porcupine with long quills on the back and sides that are raised into a crest, and the smaller brush-tailed porcupine, which has a small tuft of quills at the end of its thin tail. Both species are almost always seen at night.</p> 
      '''
      confusions: ['rodent']
      confusionsDetail: [' (although porcupines are rodents, please mark them separately)']
      exampleImages: ["./assets/guide/porcupine-1.jpg", "./assets/guide/porcupine-2.jpg", "./assets/guide/porcupine-3.jpg"]
    },

    {
      header: 'red duiker'
      subHeader: '<em>Sylvicapra</em> and <em>Cephalophus</em> genuses'
      description: '''
        <p>Use this option to mark small to medium duikers with chestnut-red fur; for example: the bush duiker which is small and reddish-brown, or the Bay duiker, notable for its red body colour and black stripe down its back. Like other duikers, they have arched backs, stocky bodies and slender legs. Some species are seen mainly at night, and others during the day.</p>

        <p class="talk-link"><a href="http://talk.chimpandsee.org/#/boards/BCP000000e/discussions/DCP0000asr" target="_blank">Duiker Guide</a></p>
      '''
      confusions: ['small antelope', 'large ungulate']
      exampleImages: ["./assets/guide/red-duiker-1.jpg", "./assets/guide/red-duiker-2.jpg", "./assets/guide/red-duiker-3.jpg"]
    },

    {
      header: 'red river hog'
      subHeader: '<em>Potamochoerus porcus</em>'
      description: '''
        <p>Pudgy pig-like animal notable for its bright red fur and its curled, pointed, elfin ears with white ear-tufts. The large muzzle is black with two small tusks and white markings around the eyes. Longer fur on flanks and underbelly. Has a line of spiky blonde hair down the spine.  Seen both at night and during the day.  Bushpigs, close relatives of red river hogs, should also be marked using this classifications. </p> 
      '''
      confusions: ['giant forest hog', 'warthog']
      exampleImages: ["./assets/guide/red-river-hog-1.jpg", "./assets/guide/red-river-hog-2.jpg", "./assets/guide/red-river-hog-3.jpg"]
    },

    {
      header: 'reptile'
      subHeader: '<em>Reptilia</em> class'
      description: '<p>Reptiles that may be found in Africa include lizards, snakes, turtles, and crocodiles. Reptiles typically have shells or scales, and are often colored in earthtones (though some snakes may have vibrant coloration). Mark all reptiles as "reptile."</p>'
      exampleImages: ["./assets/guide/reptiles-1.jpg", "./assets/guide/reptiles-2.jpg", "./assets/guide/reptiles-3.jpg"]
    },

    {
      header: 'rodent'
      subHeader: '<em>Rodentia</em> order'
      description: '''
        <p>Rodents of Africa include mice, squirrels, gerbils, and rats, but not hares, which should be marked other non-primate. These animals are typically small, with short limbs, thick bodies, and long tails. Rats and mice are almost always seen at night, while squirrels are almost always seen during the day or at dawn/dusk.  (Note: please mark porcupines separately.)</p>
      '''
      confusions: ['other (non-primate)']
      confusionsDetail: [':hyrax or hare']
      exampleImages: ["./assets/guide/rodent-1.jpg", "./assets/guide/rodent-2.jpg", "./assets/guide/rodent-3.jpg"]
    },

    {
      header: 'small antelope'
      subHeader: '<em>Bovidae</em> family'
      description: '''
        <p>Use this option to mark any small antelope other than a listed type of duiker; for instance: bushbuck, royal antelope, dik-dik, oribi, pygmy antelope, reedbuck, etc.</p>
      '''
      confusions: ['duiker', 'large ungulate']
      exampleImages: ["./assets/guide/sm-antelope-1.jpg", "./assets/guide/sm-antelope-2.jpg", "./assets/guide/sm-antelope-3.jpg"]
    },

    {
      header: 'small grey duiker'
      subHeader: '<em>Cephalophus monticola</em> and <em>Cephalophus maxwelli</em>'
      description: '''
        <p>Some of the smallest antelopes. Coat ranges from light brown to blue-grey with paler chest and underbelly. Small spiky horns in most males and some females. Stocky body, arched back, large hindquarters and thin legs. Usually seen during the day or at dawn/dusk.</p>

        <p class="talk-link"><a href="http://talk.chimpandsee.org/#/boards/BCP000000e/discussions/DCP0000asr" target="_blank">Duiker Guide</a></p>
      '''
      confusions: ['small antelope']
      exampleImages: ["./assets/guide/sm-gray-duiker-1.jpg", "./assets/guide/sm-gray-duiker-2.jpg"]
    },

    {
      header: 'small cat'
      subHeader: '<em>Felinae</em> subfamily'
      description: '<p>Several species of small felines can be found in Africa, including the caracal, the serval, the African golden cat, and the African wildcat. Any cat smaller than a leopard or a cheetah can be classified as a "small cat." Please note that viverrids, like civets and genets, are not cats, and should be marked as "other (non-primate)."</p>'
      exampleImages: ["./assets/guide/small-cat-1.jpg", "./assets/guide/small-cat-2.jpg", "./assets/guide/small-cat-3.jpg"]
    },

    {
      header: 'warthog'
      subHeader: '<em>Phacochoerus africanus</em>'
      description: '''
        <p>This pig-like animal has a grey body covered sparsely with darker hairs, and mane of long, wiry hairs along its neck and back. Its tail is thick with a black tassel. It has tusks that curve up around its snout.  More often seen during the day, but sometimes seen at night.</p>
      '''
      confusions: ['red river hog', 'giant forest hog']
      exampleImages: ["./assets/guide/warthog-1.jpg", "./assets/guide/warthog-2.jpg", "./assets/guide/warthog-3.jpg"]
    },

    {
      header: 'wild dog'
      subHeader: '<em>Lycaon pictus</em>'
      description: '<p>Social pack canine with tall, solid build and mottled coat of blacks, browns, reds, and whites. Muzzle is black and tail is typically white-tipped. Build is similar to domestic dogs and lacks hyenas\' sloped backs.</p>'
      exampleImages: ["./assets/guide/wild-dog-1.jpg", "./assets/guide/wild-dog-2.jpg", "./assets/guide/wild-dog-3.jpg"]
    },

    {
      header: 'zebra duiker'
      subHeader: '<em>Cephalophus zebra</em>'
      description: '''
        <p>Easily identifiable by the unique dark zebra-like stripes that cover its chestnut-colored back. Like other duikers, it has an arched back and stocky body with slender legs. The head has conical horns, the muzzle is black, and the lower jaw and undersides white. Usually seen during the day or at dawn/dusk.</p> 
        <p class="talk-link"><a href="http://talk.chimpandsee.org/#/boards/BCP000000e/discussions/DCP0000asr" target="_blank">Duiker Guide</a></p>
      '''
      exampleImages: ["./assets/guide/zebra-duiker-1.jpg"]
      credit: "Credit: Brent Huffman - Ultimate Ungulate Images."
    }
  ],

  behaviors: [
    {
      header: 'aggression'
      description: 'Animal is displaying angry and/or threatening behaviour directed towards another animal or towards the camera.'
    },

    {
      header: 'camera reaction'
      description: 'Animal is directly reacting to the presence of the video camera. The animal can be staring at the camera
      while being interested or wary, or poking at the camera. Sometimes you will see an animal
      look into the camera, walk by it, and then jostle the camera from behind, causing the video to shake.'
    },

    {
      header: 'carrying object'
      description: 'Animal (usually a primate or an elephant) is carrying anything like fruit or a stick. Animal may also
      be carrying fruit, or, in some cases, may be carrying meat from a hunt—if you suspect a chimpanzee
      is carrying meat, please discuss it in Talk.'
    },

    {
      header: 'carrying young/clinging'
      description: 'Animal is carrying a younger animal on its back or front, or a younger animal is clinging to an older
      animal in some way.'
    },


    {
      header: 'climbing'
      description: 'Animal is moving in a mostly vertical direction, usually in a tree or liana'
    },

    {
      header: 'cross-species interaction'
      description: 'Animal is doing something (interacting) with another animal of a different species. Interacting
      means when the actions of one individual is followed by an action in another individual whereby
      the second appears to be a response to the first one. This does not include two different species
      just walking by the camera or simply appearing at the same time in the video.'
    },

    {
      header: 'drinking/feeding'
      description: 'Animal is drinking or eating food. If the animal or animals, especially chimpanzees, can be seen
      sharing food with others (often meat, nuts, or large fruits), please make a special note in Talk!'
    },

    {
      header: 'drumming'
      description: 'Chimpanzees display a behaviour called "drumming" whereby they run up to a tree and repeatedly
      hit on it with their hands and/or feet to make a drumming sound. When you see any repeated
      hitting of a hard surface with hands and/or feet, consider it drumming. Pay very special attention to
      whether the chimpanzee drums with a stone; if yes, make sure to select the "Tool Use" button as well!'
    },

    {
      header: 'grooming'
      description: 'Animal is cleaning itself or another animal. In chimpanzees, this is often seen as one animal
      scratching or inspecting the fur/hair of another animal and picking things out of the hair (and
      sometimes even eating these things).'
    },

    {
      header: 'in a tree'
      description: 'Animal is perched on a tree, climbing a tree, or is travelling through the trees at any point during the video.'
    },

    {
      header: 'nursing'
      description: 'Female animal is giving a teat to its young, which is then suckling to obtain milk.'
    },

    {
      header: 'on the ground'
      description: 'Animal is on the ground, either standing or moving.'
    },

    {
      header: 'playing'
      description: 'Animal is playing. Play behaviours are often normally expressed behaviours that are done out of
      context. For example, you may see a chimpanzee performing a threat, hitting, or chasing, but doing
      so without aggression. In chimpanzees, this is often (but not always) accompanied by a play-face,
      similar to a kind of smile.'
    },

    {
      header: 'resting'
      description: 'Animal is sitting, lying down, sleeping, or otherwise appears relaxed.'
    },

    {
      header: 'sex/mounting'
      description: 'Animals are having sexual intercourse or mounting each other. Many primate dominance
      interactions often include mounting that looks very sexual but is not in fact sex.'
    },

    {
      header: 'social interaction'
      description: 'Animal is doing something (interacting) with another animal of the same species. Interacting means
      that the actions of one individual is followed by an action in another individual, whereby the second
      appears to be a response to the first one. This does not include two individuals just walking by the
      camera or simply appearing at the same time in the video.'
    },

    {
      header: 'tool usage'
      description: 'Tool use if when an animal uses an external detached object to attain a goal. This is primarily for
      chimpanzees where you will see them using a tool to accomplish a task. This can be one or a series
      of stick tools for collecting insects, honey or algae, a wooden or stone hammer to crack nuts, or
      stone or wooden anvils on which they smash fruit. Seeing a chimpanzee throwing a stone at a tree
      is also tool use. Keep your eyes peeled for even more types of tool use that might not be on this list!'
    },

    {
      header: 'traveling'
      description: 'Animal is walking, running, or otherwise moving and does not stop in front of the camera for long, if
      at all. Animal could be hunting or fleeing as well. If an animal appears to be hunting, please make a
      special note in Talk!'
    },

    {
      header: 'vocalizing'
      description: 'Animal is making cries or other vocal noises.'
    }
  ]
}

module.exports = guideDetails
