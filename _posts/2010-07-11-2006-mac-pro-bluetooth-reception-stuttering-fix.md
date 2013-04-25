---
layout: post
title: 2006 Mac Pro Bluetooth reception/stuttering fix
published: true
---

I now have an [Apple Magic Mouse][] and [Apple Wireless Keyboard][] and
they are the most awesome things ever. However, when I first set them
up, the performance of the mouse in particular was rather spotty; every
so often, the cursor would lag and stutter, as though the computer were
trying to catch up to the movement of the mouse (which I knew couldn't
be the case with my 2x 3GHz dual-core, 4GB RAM beast of a machine).
Google led me to a [thread on the Mac Rumors forums][] discussing that
exact issue, specifically a post which describes a very specific wiring
fix. [This fix][] worked perfectly for me, so I'm linking to and
restating it here (again, this is for 2006 Mac Pros with model
designation "1,1"):

<!-- more -->

 1. Shut down the computer, unplug everything from it, take it into a
    room without a carpeted floor, and open the case. (Follow your
    standard static prevention protocols throughout.)
 2. Open the case and slide out hard drive bay #2. The Airport
    and Bluetooth cards are directly below where the second hard drive
    goes, and are much easier to access without the drive in the way.
 3. There should be three wires attached to the Airport and Bluetooth
    cards: two to the Airport card, one to the Bluetooth card. In my
    case, these wires were labeled (from top to bottom) "3," "1," and
    "BT." There should be one more wire which is detached and has a
    rubber sleeve over the contact; for me this wire was labeled "2."
 4. Unplug wire "BT" from the Bluetooth card and put the rubber sleeve
    from wire 2 over it. The wires snap into and out of the contacts,
    but are a little tricky to get positioned just right if you have
    normal- to large-sized hands, and require a little pressure to
    snap into place. In general, be careful.
 5. Unplug wire 1 (the wire connected to the bottom contact on the
    Airport card) and plug it into the Bluetooth card. The wire may
    seem a bit short, but it'll reach; don't yank on it too hard.
 6. Plug wire 2 (the originally disconnected wire) into the bottom
    contact on the Airport card (where wire 1 had been). Push wire "BT"
    out of the way (or leave it hanging where it is, it doesn't
    matter).
 7. Put the hard drive back in and close everything back up.

This should fix the problem; it did for me: the cursor no longer
stutters, and both mouse and keyboard are working very smoothly. YMMV,
but share your results here or on whatever other venue or forum you
like.

[Apple Magic Mouse]: http://www.apple.com/magicmouse/
[Apple Wireless Keyboard]: http://www.apple.com/keyboard/
[thread on the Mac Rumors forums]: http://forums.macrumors.com/showthread.php?p=8746630
[This fix]: http://forums.macrumors.com/showthread.php?p=8746630#post8748795
