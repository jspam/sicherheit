<TeXmacs|1.0.7.10>

<style|generic>

<\body>
  <doc-data|<doc-title|Sicherheit>>

  <subsection|Einf�hrung>

  <\description>
    <item*|Kerckhoffs' Prinzip>Sicherheit des Verschl�sselungsverfahrens
    beruht auf der Geheimhaltung des Schl�ssels, nicht des Verfahrens.
  </description>

  <subsection|Symmetrische Verschl�sselung>

  <\description>
    <item*|Symmetrische Verschl�sselung>Alice und Bob haben gemeinsames
    Geheimnis <math|K>

    Chiffrat <math|C\<assign\>Enc<around*|(|K,M|)>>, Nachricht
    <math|M\<assign\>Dec<around*|(|K,C|)>>

    <item*|C�sar-Verfahren>Verschiebe Buchstaben um <math|K>

    <item*|Vigen�re-Verfahren>Schl�ssel <math|K\<in\><around*|{|0,\<ldots\>,25|}><rsup|m>>,
    <math|m> Schl�ssell�nge

    <math|\<Rightarrow\>> aber: Periodische Wiederverwendung des Schl�ssels

    <item*|One-Time-Pad (OTP)>Schl�ssel so lang wie Nachricht.
    <math|Enc<around*|(|K,M|)>=M\<oplus\>K>,
    <math|Dec<around*|(|K,C|)>=C\<oplus\>K>, wobei der Schl�ssel
    gleichverteilt gezogen ist.

    Nachteil 1) Schl�ssel darf nicht wiederverwendet werden (sonst
    <math|C\<oplus\>C<rprime|'>=M\<oplus\>M<rprime|'>>)

    Nachteil 2) Chiffrat verwundbar <math|C\<oplus\>X=<around*|(|M\<oplus\>X|)>\<oplus\>K>

    Nachteil 3) unhandlich

    <item*|Stromchiffren>Ersetze unhandliches OTP durch OTP-\RSimulation``
    mit kurzem Schl�ssel <math|K>. Generiere daraus
    <math|K<rprime|'>\<assign\>G<around*|(|K|)>\<in\><around*|{|0,1|}><rsup|n>>
    und verwende <math|K<rprime|'>> f�r OTP.

    Ziel: Pseudozufall <math|G<around*|(|K|)>> soll aussehen wie echter
    Zufall

    <\description>
      <item*|Struktur von Stromchiffren>Interner Zustand
      <math|K\<in\><around*|{|0,1|}><rsup|k>>, Anfangszustand <math|K>. Jeder
      Schritt erzeugt ein Bit als Ausgabe:
      <math|SC<around*|(|K|)>\<assign\><around*|(|b,K<rprime|'>|)>> mit
      <math|K<rprime|'>\<in\><around*|{|0,1|}><rsup|k>>. Bitfolge
      <math|b<rsub|i>> ist der Schl�ssel <math|G<around*|(|K|)>>.

      <item*|Schieberegister (LFSR, Linear Feedback Shift Register)>VL02,
      Seite 6. Ausgabe <math|b\<assign\>K<rsub|1>> (erstes Bit von <math|K>),
      neues Zustandsbit <math|z\<assign\><big-around|\<sum\>|<rsub|i=1><rsup|n>\<alpha\><rsub|i>K<rsub|i>>
      mod 2>.

      UNSICHER, selbst wenn <math|\<alpha\><rsub|i>> geheim.

      <item*|Eigenschaften>Schnell (vor allem in Hardware), ein oder mehrere
      LFSRs.

      Algebraische Angriffe m�glich, wg. Schl�sselupdate Synchronisation
      n�tig (TODO: ?), wie bei OTP Chiffrate verwundbar.
    </description>

    <item*|Blockchiffren>Zentraler Baustein: invertierbare Funktion:
    <math|E:<around*|{|0,1|}><rsup|k>\<times\><around*|{|0,1|}><rsup|\<ell\>>\<rightarrow\><around*|{|0,1|}><rsup|\<ell\>>>
    (Schl�ssel <math|\<times\>> Klartextblock <math|\<rightarrow\>>
    Chiffratblock). <math|E> + verschiedene <em|Betriebsmodi>
    <math|\<rightarrow\>> <math|Enc>

    <\description>
      <item*|Electronic Codebook Mode (ECB)>Teile <math|M> in
      <math|\<ell\>>-Bit-Bl�cke auf und verschl�ssele jeden Block mit
      demselben Schl�ssel <math|K>.

      <math|+> einfach, kein Zustandsupdate n�tig, keine Synchronisation
      n�tig

      -- Gleiche Nachricht <math|\<Rightarrow\>> gleiches Chiffrat,
      Umsortieren/Einf�gen von Chiffratbl�cken m�glich

      <item*|Cipher Block Chaining Mode (CBC)>Behebt Nachteile des ECB: Setze
      <math|C<rsub|0>\<assign\>IV> (Initialisierungsvektor), setze
      <math|C<rsub|i>\<assign\>E<around*|(|K,M<rsub|i>\<oplus\>C<rsub|i-1>|)>>.

      Initialisierungsvektor muss nicht geheim sein (darf aber nicht
      ver�nderbar sein)!

      Visualisierung siehe <hlink|http://de.wikipedia.org/wiki/Cipher_Block_Chaining_Mode|http://de.wikipedia.org/wiki/Cipher_Block_Chaining_Mode>

      Entschl�sselung: <math|M<rsub|i>\<assign\>D<around*|(|K,C<rsub|i>|)>\<oplus\>C<rsub|i-1>>

      + Gleiche Nachricht <math|\<Rightarrow\>> unterschiedliche Chiffrate,
      Umsortieren f�hrt zu fehlerhaften Bl�cken (Fehler im Geheimtextblock
      f�hrt zu Fehler bei diesem und n�chstem Block)

      -- Synchronisation n�tig (da vorheriges Chiffrat bekannt sein muss

      <item*|Cipher Feedback Mode (CFB)><math|C<rsub|i>\<assign\>E<around*|(|K,C<rsub|i-1>|)>\<oplus\>M<rsub|i>>
      (�hnlich Stromchiffre)

      <item*|Output Feedback Mode (OFB)><math|C<rsub|i>\<assign\><wide*|E<around*|(|K,D<rsub|i-1>|)>|\<wide-underbrace\>><rsub|D<rsub|i>>\<oplus\>M<rsub|i>>
      (ist letztlich Stromch.)

      <item*|Data Encryption Standard (DES)><math|E> mit
      <math|k=56,\<ell\>=64>. Mittlerweile veraltet, da zu kurzer Schl�ssel

      Rundenfunktion <math|F:<around*|{|0,1|}><rsup|48>\<times\><around*|{|0,1|}><rsup|32>\<rightarrow\><around*|{|0,1|}><rsup|32>>;
      Feistelstruktur (<math|F> muss nicht invertierbar sein, Entschl�sselung
      wie Verschl�sselung mit Teilschl�sseln in umgekehrter Reihenfolge.)

      <item*|2DES>Naive Verbesserung (zwei Schl�ssel);
      Meet-in-the-Middle-Angriff m�glich

      <item*|3DES>Drei Schl�ssel, 3x DES anwenden <math|\<Rightarrow\>>
      sicherer

      <item*|Advanced Encryption Standard (AES)><math|E> mit
      <math|k\<in\><around*|{|128,192,256|}>>, <math|\<ell\>=128>, keine
      Feistelstruktur, nach heutigem Kenntnisstand sicher
    </description>

    <item*|Angriffe auf Blockchiffren>

    <\description>
      <item*|Lineare Kryptoanalyse>Finde <math|\<bbb-F\><rsub|2>>-lineare
      Abh�ngigkeiten zwischen den Bits von <math|X> und
      <math|E<around*|(|K,X|)>>. Bei Feistel-Verfahren mit <math|n> Runden
      indirekter Angriff m�glich (Erweiterung auf <math|n-1> Runden +
      vollst�ndige Suche �ber ersten/letzten Schl�ssel)

      <item*|Differentielle Kryptoanalyse>Betrachte Ausgabedifferenzen in
      Abh�ngigkeit von Eingabedifferenzen (dabei f�llt Rundenschl�ssel weg)
    </description>

    <item*|Formalisierung von Sicherheit>Nur passive Angriffe betrachtet.

    <\description>
      <item*|Semantische Sicherheit>Chiffrat verr�t nur die L�nge der
      Nachricht. (Jede Information, die aus dem Chiffrat abgeleitet werden
      kann, kann aus einer beliebigen Nachricht gleicher L�nge abgeleitet
      werden)

      Existenz von (mehrfach benutzbaren) semantisch sicheren Verfahren
      <math|\<Rightarrow\> P\<neq\>N P>.

      <item*|IND-CPA (Indistinguishability under chosen-plaintext
      attacks)>Kein PPT- Angreifer <math|\<cal-A\>> kann Chiffrate
      selbstgew�hlter Klartexte unterscheiden.

      Spiel: <math|\<cal-A\>> hat Zugriff auf
      <math|Enc<around*|(|K,\<cdummy\>|)>>-Orakel. W�hlt zwei Nachrichten
      <math|M<rsub|1>>, <math|M<rsub|2>> gleicher L�nge, bekommt das Chiffrat
      einer der beiden Nachrichten und muss raten, zu welcher der Nachrichten
      es geh�rt.

      Schema IND-CPA-sicher, wenn f�r alle Angreifer die
      Gewinnwahrscheinlichkeit minus <math|<frac|1|2>> vernachl�ssigbar ist.
      Insbesondere sind deterministische Verfahren nie IND-CPA-sicher!

      IND-CPA �quivalent zur semantischen Sicherheit.

      <\description>
        <item*|ECB-Mode>deterministisch <math|\<Rightarrow\>> nicht sicher

        <item*|CBC>IND-CPA-sicher, wenn <math|E<around*|(|K,\<cdummy\>|)>>
        f�r zuf�lliges <math|K> ununterscheidbar von einer Zufallsfunktion
        <math|R> ist.

        Beweis: Baue aus IND-CPA-Angreifer einen <math|E/R>-Unterscheider

        <item*|Stromchiffren>Zustandsbehaftete Stromchiffre IND-CPA-sicher,
        wenn verwendetes <math|SC<around*|(|K|)>> f�r zuf�lliges <math|K>
        ununterscheidbar von zuf�lligem <math|U>.

        <item*|Feistel-Schema>Wenn <math|F<around*|(|K,\<cdummy\>|)>> mit
        zuf�lligem <math|K> ununterscheidbar von einer zuf�lligen Funktion,
        dann ist <math|Enc<around*|(|K,\<cdummy\>|)>> ununterscheidbar von
        einer zuf�lligen invertierbaren Funktion.
      </description>
    </description>
  </description>

  <subsection|Hashfunktionen>

  <\description>
    <item*|Definition><math|H<rsub|k> : <around*|{|0,1|}><rsup|\<ast\>>\<rightarrow\><around*|{|0,1|}><rsup|k>>,
    kurzer \RFingerabdruck`` gro�er Daten. Kryptographische Hashfunktion:
    kollisionsresistent und/oder Einwegfunktion.

    <item*|Kollisionsresistenz>Jeder PPT-Algorithmus findet nur mit h�chstens
    vernachl�ssigbarer Wahrscheinlichkeit eine Kollision.

    <\description>
      <item*|PPT (Probabilistic Polynomial Time)>Algorithmus l�uft in
      Polynomialzeit und gibt \RJa`` mit Wahrscheinlichkeit
      <math|\<gtr\><frac|1|2>> aus gdw. Antwort \RJa`` lautet.

      <item*|Vernachl�ssigbare Funktion><math|<around*|\||f|\|>> verschwindet
      asymptotisch schneller als der Kehrwert eines beliebigen Polynoms.
    </description>

    <item*|Einwegeigenschaft (bei Hashfunktionen: Preimage Resistance)>Eine
    Funktion <math|H<rsub|k>> ist eine Einwegfunktion bez�glich der
    Urbildverteilung <math|\<cal-X\><rsub|k>>, wenn jeder PPT-Algorithmus nur
    mit h�chstens vernachl�ssigbarer Wahrscheinlichkeit <em|ein> Urbild eines
    gegebenen, aus <math|\<cal-X\><rsub|k>> gezogenen Bildes findet.

    Folgt aus Kollisionsresistenz: Zu jedem <math|H>-Invertierer kann ein
    Kollisionsfinder angegeben werden: W�hle Urbild <math|X> beliebig,
    berechne <math|H<around*|(|X|)>> und setze
    <math|X<rprime|'>\<assign\>H<rsup|-1><around*|(|X|)>>. Es ist
    <math|X=X<rprime|'>> mit Wahrscheinlichkeit
    <math|<frac|1|<around*|\||H<rsup|-1><around*|(|H<around*|(|X|)>|)>|\|>>>
    und mit Wahrscheinlichkeit <math|\<geqslant\> 1-<frac|1|2<rsup|k>>> hat
    <math|H<around*|(|X|)>> mehr als ein Urbild <math|\<Rightarrow\>>
    Kollisionsfinder erfolgreich mit Wkt. <math|\<geqslant\> <frac|1|2>
    P-<frac|1|2<rsup|k+1>>>, wobei <math|P> Erfolgswahrscheinlichkeit des
    Invertierers.

    <item*|Target Collision Resistance>Gegeben <math|X>, finde
    <math|X<rprime|'>> mit <math|H<around*|(|X|)>=H<around*|(|X<rprime|'>|)>>.

    Kollisionsresistenz <math|\<Rightarrow\>> Target Collision Resistance
    <math|\<Rightarrow\>> Einwegeigenschaft.

    <item*|Merkle-Damg�rd-Konstruktion>Baue Hashfunktion aus einfacherem
    Baustein: Kompressionsfunktion <math|F:<around*|{|0,1|}><rsup|2k>\<rightarrow\><around*|{|0,1|}><rsup|k>>.
    Wiederholte Anwendung von <math|F> auf Nachrichtenbl�cke, zu Anfang mit
    einem Initialisierungsvektor.

    <math|F> kollisionsresistent <math|\<Rightarrow\>> <math|H<rsub|MD>>
    kollisionsresistent

    <item*|Beispiele>MD5 (Ausgabe 128 Bits, gebrochen), SHA-1 (Ausgabe 160
    Bits, gebrochen), SHA-3 (Ausgabel�nge variabel)

    <item*|Birthday Attack>Betrachte viele <math|H<around*|(|X<rsub|i>|)>>
    f�r zuf�llige <math|X<rsub|i>>. F�r <math|2<rsup|k/2>> verschiedene
    <math|X<rsub|i>> gibt es Kollision unter den
    <math|H<around*|(|X<rsub|i>|)>> mit Wahrscheinlichkeit
    <math|p\<gtr\><frac|1|11>>.

    <item*|Lehre>Ausgabel�nge <math|\<geqslant\>> <math|k> Bits f�r
    <math|k/2> Bits \RSicherheit``
  </description>

  <subsection|Asymmetrische Verschl�sselung>

  <\description>
    <item*|Idee>Bei symmetrischer Verschl�sselung viele Schl�ssel n�tig:
    <math|<matrix|<tformat|<table|<row|<cell|n>>|<row|<cell|2>>>>>> f�r
    <math|n> Benutzer. Schl�sselverteilung ist auch schwierig.

    Grundidee: �ffentlicher Schl�ssel <em|pk>, geheimer Schl�ssel <em|sk>,
    gemeinsam generiert: <math|<around*|(|pk,sk|)>\<leftarrow\>Gen<around*|(|1<rsup|k>|)>>.
    <math|C\<assign\>Enc<around*|(|pk,M|)>>; <math|M=Dec<around*|(|sk,C|)>>.

    <item*|RSA>(Rivest/Shamir/Adleman) <math|pk=<around*|(|N,e|)>\<nocomma\>>,
    <math|sk=<around*|(|N,d|)>>, wobei <math|N=P*Q> f�r gro�e Primzahlen
    <math|P\<neq\>Q> und <math|e\<cdot\>d=1 mod
    <around*|(|\<varphi\><around*|(|N|)>=<around*|(|P-1|)><around*|(|Q-1|)>|)>>.
    Nachrichtenraum <math|\<bbb-Z\><rsub|N>>

    <math|Enc<around*|(|pk,M|)>=M<rsup|e>> mod <math|N>,
    <math|Dec<around*|(|sk,C|)>=C<rsup|d>> mod <math|N>

    <\description>
      <item*|Schl�sselgenerierung>W�hle <math|P,Q> zuf�llig; w�hle <math|e>
      zuf�llig solange, bis invertierbar modulo
      <math|\<varphi\><around*|(|N|)>>; berechne <math|d=e<rsup|-1>> mod
      <math|\<varphi\><around*|(|N|)>> mit erweitertem Euklid: EE liefert
      <math|\<alpha\>,\<beta\>> mit <math|\<alpha\>\<cdot\>e+\<beta\>\<cdot\>\<varphi\><around*|(|N|)>=1>,
      setze also <math|d\<assign\>\<alpha\> mod \<varphi\><around*|(|N|)>>.

      <item*|Korrektheit>

      <\description>
        <item*|Kleiner Satz von Fermat><math|P> prim,
        <math|M\<in\><around*|{|1,\<ldots\>,P-1|}>>: <math|M<rsup|P-1>=1 mod
        P>

        <item*|Chinesischer Restsatz><math|<around*|(|X=Y mod P|)>> und
        <math|<around*|(|X=Y mod Q|)>> <math|\<Rightarrow\>> <math|X=Y mod
        N>, wenn <math|N=P*Q >und <math|P,Q> teilerfremd
      </description>

      <item*|Sicherheit>RSA ist deterministisch <math|\<Rightarrow\>> nicht
      semantisch sicher. Au�erdem: Chiffrat enth�lt Information
      <math|f<around*|(|M|)>=M<rsup|e> mod N> �ber <math|M>, nicht allein aus
      L�nge ablesbar.

      <item*|Weitere Angriffe><math|e=3> f�r alle Benutzer problematisch,
      wenn <math|M> an <math|\<geqslant\> 3> Benutzer gesendet wird (kennen
      <math|M<rsup|e>=M<rsup|3> mod n<rsub|1>\<cdot\>n<rsub|2>\<cdot\>n<rsub|3>>
      wg. chin. Restsatz, ziehe dritte Wurzel). Gleiches <math|N> f�r alle
      Benutzer ist auch problematisch.

      <item*|Homomorphie><math|Enc<around*|(|pk,M|)>\<cdot\>Enc<around*|(|pk,M<rprime|'>|)>=Enc<around*|(|pk,M\<cdot\>M<rprime|'>|)>>.

      <item*|Reparatur: RSA-OAEP>Padding; allerdings rechenaufw�ndig.
    </description>

    <item*|ElGamal>Zyklische Gruppe <math|\<bbb-G\>=<around*|\<langle\>|g|\<rangle\>>>.
    <math|pk=<around*|(|\<bbb-G\>,g,g<rsup|x>|)>>,
    <math|sk=<around*|(|\<bbb-G\>,g,x|)>> mit zuf�lligem <math|x>.

    <math|Enc<around*|(|pk,M|)>=<around*|(|g<rsup|y>,g<rsup|x*y>\<cdot\>M|)>>
    mit zuf�lligem <math|y>; <math|Dec<around*|(|sk,<around*|(|Y,Z|)>|)>=Z/Y<rsup|x>>
    (alles modulo <math|p>)

    Homomorph wie RSA (nicht-homomorphe Varianten existieren).

    Geeignete Gruppen <math|\<bbb-G\>:> Echte Untergruppen von
    <math|\<bbb-Z\><rsub|P><rsup|\<ast\>>> mit <math|P> prim, Untergruppen
    von <math|\<bbb-F\><rsub|q><rsup|*\<ast\>>> mit <math|q> Primpotenz,
    Untergruppen von elliptischer Kurve <math|E<around*|(|\<bbb-F\><rsub|q>|)>>

    <\description>
      <item*|Sicherheit>Unter naheliegender Annahme semantisch sicher.
    </description>

    <item*|Semantische Sicherheit f�r PK-Verfahren>wie f�r symmetrische
    Verfahren, �quivalent zu IND-CPA.
  </description>

  <subsection|Symmetrische Nachrichtenauthentifikation: MACs>

  <\description>
    <item*|Ziel>Authentifizierte �bermittlung auf unauthentifiziertem Kanal:
    Sch�tze Nachricht vor Ver�nderungen, indem \RUnterschrift``
    <math|\<sigma\>> mit Nachricht gesendet wird.

    <item*|Message Authentication Code (MAC)>Gemeinsames Geheimnis <math|K>;
    <math|\<sigma\>\<leftarrow\>Sig<around*|(|K,M|)>>, Verifizieren
    <math|Ver<around*|(|K,M,\<sigma\>|)>\<in\><around*|{|0,1|}>>.

    Korrektheit <math|Ver<around*|(|K,M,\<sigma\>|)>=1> f�r alle
    <math|K,M,\<sigma\>\<leftarrow\>Sig<around*|(|K,M|)>>.

    <item*|EUF-CMA-Sicherheit (Existential unforgability under chosen message
    attack)><verbatim|<math|\<cal-A\>>> hat Zugriff auf
    <math|Sig<around*|(|K,\<cdummy\>|)>>-Orakel; gewinnt, wenn er neue(!)
    Nachricht <math|M> mit g�ltiger Signatur erzeugen kann.

    Passiver Angriff; <math|\<cal-A\>> erh�lt keinen Zugriff auf <math|Ver>.
    Ist aber bei vielen Verfahren (z.B. eindeutiges <math|\<sigma\>>)
    �quivalent zu Definition mit <math|Ver>-Orakel f�r <math|\<cal-A\>>.

    <item*|Hash-Then-Sign>Signiere <math|H<around*|(|M|)>> statt <math|M>.
    Ist EUF-CMA-sicher, wenn das zugrundeliegende Signaturverfahren
    EUF-CMA-sicher ist und <math|H> kollisionsresistent.

    <item*|Pseudorandom Functions>Ununterscheidbar von echtem Zufall.
    Beispiel <math|PRF<around*|(|K,X|)>=H<around*|(|K,X|)>>. Aber z.B. bei
    MD-Konstruktion wird PRF-Eigenschaft gebrochen f�r Nachrichten
    unterschiedlicher L�nge (Hashwert kann \Rerweitert`` werden:
    <math|H<around*|(|X,X<rprime|'>|)>=F<around*|(|X<rprime|'>,H<around*|(|X|)>|)>>).

    <item*|PRF und Hashfunktion <math|\<rightarrow\>>
    MAC><math|Sig<around*|(|K,M|)>=PRF<around*|(|K,H<around*|(|M|)>|)>> f�r
    PRF und kollisionsresistente Hashfunktion <math|H> EUF-CMA-sicher.

    Konkret:

    <\description>
      <item*|<math|H\<in\><around*|{|MD5,SHA1|}>>><math|Sig<around*|(|K,M|)>=H<around*|(|K,M|)>>,
      unsicher [<math|H<around*|(|K,M|)>> ist Hash von Konkatenation von
      <math|K> und <math|M>!]

      <item*|Besser><math|Sig<around*|(|K,M|)>=H<around*|(|K,H<around*|(|M|)>|)>>

      <item*|HMAC><math|Sig<around*|(|K,M|)>=H<around*|(|K\<oplus\>opad,
      H<around*|(|K\<oplus\>ipad,M|)>|)>>, wobei
      <math|opad,ipad\<in\><around*|{|0,1|}><rsup|k>> feste Konstanten des
      Verfahrens sind
    </description>
  </description>

  <subsection|Asymmetrische Nachrichtenauthentifikation: Digitale Signaturen>

  <\description>
    <item*|Motivation>Wie bei symmetrischer Verschl�sselung: viele Schl�ssel,
    Verteilungsproblem

    <item*|Public/Secret key><math|<around*|(|pk,sk|)>\<leftarrow\>Gen<around*|(|1<rsup|k>|)>>.
    <math|\<sigma\>\<leftarrow\>Sig<around*|(|sk,M|)>>,
    <math|Ver<around*|(|pk,M,\<sigma\>|)>\<in\><around*|{|0,1|}>>.
    Korrektheit wie bei MAC.

    <item*|EUF-CMA>Wie oben, Angreifer hat Zugriff auf
    <math|Sig<around*|(|sk,\<cdummy\>|)>>-Orakel.

    <item*|RSA-Signaturen>Verschl�sselung:
    <math|Enc<around*|(|pk,M|)>=M<rsup|e> mod N>.
    <math|Dec<around*|(|sk,C|)>=C<rsup|d> mod N>

    NEU Signatur: <math|Sig<around*|(|sk,M|)>=M<rsup|d> mod N>;
    <math|Ver<around*|(|pk,M,\<sigma\>|)>=1 :\<Leftrightarrow\>
    M=\<sigma\><rsup|e> mod N>.

    (Funktioniert nicht unbedingt f�r alle Verschl�sselungsschemata:
    Datentypproblem, <math|Enc> muss nicht deterministisch sein)

    <\description>
      <item*|Probleme>Zu (unsinniger) Signatur kann Nachricht erzeugt werden:
      <math|M\<assign\>\<sigma\><rsup|e> mod N>. Bricht EUF-CMA-Sicherheit.
      Auch Homomorphie ist ein Problem (bricht ebenfalls EUF-CMA-Sicherheit).

      <item*|L�sung: RSA-PSS (Probabilistic Signature Scheme)>Padding
      mithilfe von Hashfunktion <math|H> und MGF.

      <math|Sig<around*|(|sk,M|)>=<around*|(|pad<around*|(|M|)>|)><rsup|d>
      mod N>. <math|Ver<around*|(|pk,M,\<sigma\>|)>=1 :\<Leftrightarrow\>
      \<sigma\><rsup|e> mod N> ist g�ltiges <math|pad<around*|(|M|)>>.

      Mit idealem <math|H>, MGF EUF-CMA-sicher, wenn RSA-Funktion schwer zu
      invertieren.
    </description>

    <item*|ElGamal-Signaturen><math|pk=<around*|(|\<bbb-G\>,g,g<rsup|x>|)>>,
    <math|sk=<around*|(|\<bbb-G\>,g,x|)>> wie bei ElGamal-Verschl�sselung.
    Verwende Untergruppe (Ordnung <math|<around*|\||\<bbb-G\>|\|>=q>) von
    zyklischer Gruppe <math|<around*|\<langle\>|g|\<rangle\>>> mit Ordnung
    <math|p>.

    Setze <math|a\<assign\>g<rsup|e>> mod <math|p> f�r zuf�lliges <math|e>;
    <math|b> als L�sung von <math|a*x+e*b=M mod q>

    <math|Sig<around*|(|sk,M|)>=<around*|(|a,b|)>>,
    <math|Ver<around*|(|pk,M,\<sigma\>|)>=1
    :\<Leftrightarrow\><around*|(|g<rsup|x>|)><rsup|a>a<rsup|b>=g<rsup|M> mod
    p>. Dabei <math|a=g<rsup|e>> sowohl als <math|\<bbb-G\>>-Element als auch
    als Expontent verwendet.

    Es darf f�r verschiedene <math|M> nie dasselbe <math|e> verwendet werden,
    <math|e> darf nicht deterministisch sein.

    Wie RSA nicht EUF-CMA-sicher, da Nachricht 0 signierbar mit
    <math|<around*|(|a,b|)>=<around*|(|g<rsup|x>,-a|)>> f�r alle geheimen
    Schl�ssel <math|x>.

    <item*|Hash-then-sign>Wie bei MACs, auch EUF-CMA-Sicherheit.

    <item*|DSA (Digital Signature Algorithm)>Wie ElGamal, aber nicht
    <math|a*x+e*b=M mod q>, sondern <math|a*x+e*b=H<around*|(|M|)> mod q>.
    EUF-CMA-Sicherheit gegenw�rtig unklar.
  </description>

  <subsection|Schl�sselaustauschprotokolle>

  <\description>
    <item*|Ziel>Austausch eines gemeinsamen Schl�ssels <math|K> �ber
    unsicheren Kommunikationskanal
  </description>

  <subsubsection|Symmetrische Verfahren>

  <\description>
    <item*|Schl�sselzentrum>KC kennt Schl�ssel aller Benutzer; Kommunikation
    mit KC soll minimiert werden. Verwendung von symmetrischer
    Verschl�sselung.

    <item*|Kerberos>Aktiv sichere Verschl�sselung und synchrone Uhren n�tig,
    Sicherheit nicht formal gekl�rt. Authentifiziert Alice und Bob auch.

    <\enumerate-numeric>
      <item>Alice schickt <math|<around*|(|Alice,Bob|)>> an KC

      <item>KC schickt Schl�ssel an Alice (einmal verschl�sselt mit
      <math|K<rsub|A>>, einmal mit <math|K<rsub|B>>), jeweils mit
      Zeitstempel, G�ltigkeitsdauer, Name des Kommunikationspartners

      <item>Alice schickt Zeitstempel verschl�sselt mit <math|K> sowie
      Schl�ssel verschl�sselt mit <math|K<rsub|B>> an Bob

      <item>Bob schickt Zeitstempel+1 verschl�sselt mit <math|K> an Alice
    </enumerate-numeric>
  </description>

  <subsubsection|Asymmetrische Verfahren>

  <\description>
    <item*|Public-Key Transport>Alice w�hlt <math|K> und schickt ihn
    (verschl�sselt mit <math|pk<rsub|B>>) an Bob.

    Passive Sicherheit erreicht, aktive nicht (Replay-Angriffe); nicht
    authentifiziert, wenn Kanal nicht authentifiziert.

    Authentifizierung durch zus�tzliche Signatur der �bertragenen Nachricht
    m�glich

    <item*|Diffie-Hellman-Schl�sselaustausch>�hnlich ElGamal,
    <math|\<bbb-G\>=<around*|\<langle\>|g|\<rangle\>>> gegeben.

    Alice schickt <math|g<rsup|x>> an Bob, Bob schickt <math|g<rsup|y>> an
    Alice <math|\<Rightarrow\>> gemeinsamer Schl�ssel <math|g<rsup|x*y>>.
    Kann durch das Signieren aller Nachrichten authentifiziert werden.
  </description>

  <subsubsection|TLS (Transport Layer Security)>

  <\description>
    <item*|Definition>Protokoll f�r Aufbau und Betrieb sicherer Kan�le.
    Zuerst authentifizierter asymmetrischer Schl�sselaustausch, danach
    symmetrische Verschl�sselung der Nutzdaten.

    <item*|Angriffe><verbatim|ChangeCipherSpec> Drop durch aktiven Angreifer,
    Angriff auf RSA-Padding, CRIME (Angriff auf komprimierte Kommunikation)
  </description>

  <subsubsection|Weitere Schl�sselaustauschprotokolle>

  <\description>
    <item*|IPsec>�hnlich TLS, ohne Handshake, auf niedrigerer Protokollebene

    <item*|PAKE (Password-Authenticated Key Exchange)>Alice, Bob haben
    Passwort <verbatim|pass>, wollen gemeinsamen Schl�ssel <math|K>
    aushandeln.
  </description>

  <subsection|Identifikationsprotokolle>

  <\description>
    <item*|Ziel>Asymmetrische Authentifikation von Parteien: Bob = V
    (Verifier), Alice = P (Prover).

    <item*|Nicht-interaktive Protokolle>Problematisch; �bertragene Nachricht
    kann von Angreifer verwendet werden. (FRAGE: Zeitstempel?)

    <item*|Interaktiv>V sendet Zufallszahl <math|R>, P sendet
    <math|Sig<around*|(|sk<rsub|A>,R|)>>. [Verfahren 1]

    (Gen,P,V)-sicher, wenn das Signaturverfahren EUF-CMA-sicher ist.

    <item*|Sicherheitsmodell (Gen,P,V)-Sicherheit>Schl�sselpar von
    PPT-Algorithmus <math|Gen> erzeugt. Zwei zustandsbehaftete
    PPT-Algorithmen interagieren solange, bis <math|V> 0 oder 1 ausgibt.

    Sicherheit PK-ID-Protokoll: kein PPT-Angreifer gewinnt mehr als
    vernachl�ssigbar oft: In Phase 1 darf <math|A> mit beliebig vielen
    <math|P>-Instanzen als Verifier interagieren.
    <math|<around*|(|pk<rsub|i>,sk<rsub|i>|)>> sind vom Spiel gew�hlt. In
    Phase 2 sucht <math|\<cal-A\>> ein schon vom Spiel gew�hltes
    <math|pk<rsub|i<rsup|\<ast\>>>> aus und interagiert als Prover mit einer
    V-Instanz. <math|\<cal-A\>> gewinnt, wenn <math|V> 1 ausgibt.

    Verhindert keinen Man-in-the-Middle-Angriff.

    <item*|Noch ein Protokoll><math|V> sendet Ciphertext einer Zufallszahl,
    <math|P> entschl�sselt.

    (Gen,P,V)-sicher, wenn Verschl�sselungsverfahren IND-CCA-sicher ist
    (sicher unter aktiven Angriffen)
  </description>

  <subsection|Zero-Knowledge-Protokolle>

  <\description>
    <item*|Ziel><math|V> soll nichts �ber <math|sk<rsub|A>> lernen k�nnen,
    was er nicht schon aus <math|pk<rsub|A>> berechnen kann.

    <item*|Zero-Knowledge-Eigenschaft (ZK)>Ein PK-ID-Protokoll (Gen,P,V) ist
    ZK, falls f�r jeden PPT-Angreifer <math|\<cal-A\>> ein PPT-Simulator
    <math|\<cal-S\>> existiert, sodass die Verteilung
    <math|<around*|\<langle\>|P*<around*|(|sk|)>,\<cal-A\><around*|(|1<rsup|k>,pk|)>|\<rangle\>>>
    und die Ausgabe von <math|\<cal-S\><around*|(|1<rsup|k>,pk|)>>
    ununterscheidbar sind.

    <item*|Nicht-Beispiel>Verfahren 1 von oben ist nicht ZK, da Simulator
    eine Signatur f�lschen m�sste im Widerspruch zur EUF-CMA-Eigenschaft.

    <item*|Commitments><math|Com<around*|(|M;R|)>> ist Commitment auf
    <math|M> (mit Zufall <math|R>). Beispiel:
    <math|Com<around*|(|M;R|)>=H<around*|(|M,R|)>>.

    <\description>
      <item*|Hiding-Eigenschaft>Verteilungen <math|Com<around*|(|M;R|)>> und
      <math|Com<around*|(|M<rprime|'>;R|)>> ununterscheidbar

      <item*|Binding-Eigenschaft>H�chstens vernachl�ssigbare
      Wahrscheinlichkeit, dass PPT-Angreifer
      <math|<around*|(|M<rprime|'>,R<rprime|'>|)>> findet mit
      <math|Com<around*|(|M;R|)>=Com<around*|(|M<rprime|'>,R<rprime|'>|)>>.
    </description>

    <item*|Beispiel>Graph-Dreif�rbbarkeit: <math|P> kennt Dreif�rbung, w�hlt
    Bijektion der Farben und committet sich auf permutierte Dreif�rbung.
    <math|V> w�hlt Kante; <math|P> �ffnet entsprechende Commitments; <math|V>
    akzeptiert gdw. Openings g�ltig und verschiedene Farben.

    Sicherheit im PK-ID-Sinne: <math|k> mal durchf�hren

    Simulator: <math|\<cal-S\>> �bernimmt Rolle von <math|P>, w�hlt zuf�llige
    F�rbung, interagiert mit Angreifer, spult zur�ck bei Fehler. Laufzeit
    erwartet polynomiell.

    <item*|Proof-of-Knowledge-Eigenschaft (POK)>(Gen,P,V) ist POK, falls ein
    PPT-Extraktor bei Zugriff auf einen erfolgreichen Prover einen geheimen
    Schl�ssel <math|sk> zu <math|pk> extrahieren kann.

    Beispiel bei Dreif�rbbarkeit: Wiederholtes Zur�cksetzen von <math|P> auf
    Stand nach Commitments und sukzessives W�hlen der Kanten, bis alle
    Knotenfarben bekannt.

    <item*|PK-ID-Sicherheit>Aus ZK und POK folgt noch nicht PK-ID-Sicherheit,
    da der geheime Schl�ssel aus dem �ffentlichen leicht berechenbar sein
    k�nnte. Falls aber <math|pk\<rightarrow\>sk> hard-on-average ist, dann
    folgt aus ZK und POK schon PK-ID-Sicherheit.

    <item*|Weitere Anwendungen>Beliebige NP-Aussagen in ZK beweisbar, ohne
    Zeugen herauszugeben.
  </description>

  <subsection|Benutzerauthentifikation>

  <\description>
    <item*|Motivation>Authenfizierung von Benutzer <math|B> bei Server
    <math|S> mit Passwort <verbatim|pw>. <math|S> sollte <verbatim|pw> nicht
    kennen wg. Servereinbruch.

    L�sung: Benutzer sendet <verbatim|pw>, Server speichert
    <math|H<around*|(|pw|)>>.

    <item*|W�rterbuchangriffe>Vergleiche <math|H<around*|(|pw|)>> mit
    <math|H<around*|(|pw<rprime|'>|)>> f�r alle W�rterbucheintr�ge
    <math|pw<rprime|'>>

    Sehr langsam, wenn W�rterbuch gro� <math|\<Rightarrow\>> sortiere
    W�rterbuch nach Hashwert

    Sehr gro�er Speicherplatzbedarf <math|\<Rightarrow\>> Komprimieren des
    W�rterbuchs

    <item*|Komprimieren des W�rterbuchs>Betrachte Ketten von
    Hash-Passwort-Paaren, erzeugt aus Funktion <math|f> (Hash
    <math|\<times\>> Passwort) <math|\<rightarrow\>> (Hash <math|\<times\>>
    Passwort). Sortiere nach Endpunkten und berechne Endpunkt aus
    <math|H<around*|(|pw|)>>.

    <math|f> m�glichst kollisionsfrei, sonst Ketten mit nicht eindeutigem
    Anfangspunkt m�glich

    Es m�ssen nur Anfangs- und Endpunkt gespeichert werden.

    <item*|Rainbow Tables>Korrigiert m�gliche �berlappungen von Ketten:
    Benutze <math|f<rsub|i>> f�r Spalte <math|i>. Farbe einer Spalte:
    <math|i>. Nachteil: Alle Farben von <math|H<around*|(|pw|)>> m�ssen
    probiert werden

    <item*|Gegenma�nahme Salting>Server speichert <math|salt> und
    <math|H<around*|(|salt,pw|)>>. Verhindert W�rterbuch- und
    Rainbow-Table-Angriffe.

    <item*|Gegenma�nahme Key Strengthening>Wende <math|H> sehr oft an (z.B.
    feste Anzahl oder bis Bedingung erf�llt)

    <item*|Parallelisierte Brute-Force-Angriffe>Mittlerweile effizienter als
    Rainbow Tables, dank GPUs

    <item*|Interaktive Nutzerauthentifikation>Verhindere Replay-Angriffe,
    wenn Kommunikation unsicher (z.B. Internetcafe). Nutze z.B. sichere
    Hardware (Chipkarte) und authentifiziere bei dieser mit Passwort oder PIN

    <item*|Positionsbasierte Kryptographie>Authentifikation, dass <math|P>
    sich an gegebener Position befindet. Mehrere Verifier <math|V> n�tig.

    Grunds�tzlich ist eine positionspasierte Authentifikation unter den
    bisherigen Annahmen unm�glich. L�sung z.B. speicherplatzbeschr�nkte
    Angreifer.
  </description>

  <subsection|Zugriffskontrolle>

  <\description>
    <item*|Motivation>Mehrbenutzersystem, gemeinsamer Zugriff auf Dateien mit
    verschiedenen Sicherheitsstufen

    <item*|Bell-LaPadula>Betrachte Systemzust�nde. Systemzustand kann sicher
    sein, g�ltige Anfrage �berf�hrt sicheren in sicheren Systemzustand.

    Menge <math|\<cal-S\>> von Nutzern (Subjekten), Menge <math|\<cal-O\>>
    von Dateien (Objekten), Menge <math|\<cal-A\>> von Operationen (hier:
    <verbatim|read, write, append, execute>), <math|\<cal-L\>> halbgeordnete
    Menge von Sicherheitsleveln.

    Systemzustand: besteht aus Zugriffsmenge
    <math|B\<subseteq\><around*|{|S\<times\>O\<times\>A|}>>,
    Zugriffskontrollmatrix <math|M> mit Untermengen von <math|\<cal-A\>> als
    Elementen, Tupel <math|F=<around*|(|f<rsub|s>,f<rsub|c>,f<rsub|o>|)>>,
    wobei <math|f<rsub|s>,f<rsub|c>> den maximalen bzw. aktuellen Level der
    Subjekte, <math|f<rsub|o>> den Level der Objekte beschreibt.

    <\description>
      <item*|Discrectionary Security (ds)>F�r alle Zugriffe
      <math|<around*|(|s,o,a|)>> muss <math|a\<in\>M<rsub|s,o>> gelten

      <item*|Simple Security (ss) / NoReadUp>F�r alle <strong|Lese>zugriffe
      <math|<around*|(|s,o,read|)>> muss gelten:
      <math|f<rsub|s><around*|(|s|)>\<geqslant\>f<rsub|o><around*|(|o|)>>.
      Nach einer genehmigten Anfrage wird <math|f<rsub|c><around*|(|s|)>>
      gegebenenfalls angepasst.

      <item*|Star Property (<math|\<star\>>) / NoWriteDown>F�r alle
      <strong|Schreib>zugriffe <math|<around*|(|s,o,write/append|)>> muss
      gelten: <math|f<rsub|c><around*|(|s|)>\<leqslant\>f<rsub|o><around*|(|o|)>>.
    </description>

    Nachteile: Keine Verhinderung verdeckter Kan�le, statisch, unhandlich (da
    <math|f<rsub|c>> nur wachsen kann)

    <item*|Chinese Wall>Menge <math|\<cal-C\>> von Firmen, Menge
    <math|\<cal-S\>> von Beratern, Menge <math|\<cal-O\>> von Objekten. Jedes
    Objekt <math|o> geh�rt zur Firma <math|y<around*|(|o|)>> und hat
    Konflikte mit Firmen <math|x<around*|(|o|)>\<subseteq\>\<cal-C\>>.

    Betrachte Zugriffe <math|<around*|(|s,o|)>>:

    <\description>
      <item*|Simple Security (ss)>F�r alle <math|o<rprime|'>\<in\>\<cal-O\>>,
      auf die <math|s> schon Zugriff hatte, gilt
      <math|y<around*|(|o|)>=y<around*|(|o<rprime|'>|)>> oder
      <math|y<around*|(|o|)>\<nin\>x<around*|(|o<rprime|'>|)>> (geh�ren
      entweder zur gleichen Firma wie <math|o> oder stehen nicht mit der
      Firma von <math|o> in Konflikt)

      <item*|Star Property (<math|\<star\>>)>F�r <strong|Schreib>anfragen:
      F�r alle Objekte <math|o<rprime|'>>, auf die <math|s> schon
      <strong|lesend> zugreift, gilt <math|y<around*|(|o<rprime|'>|)>=y<around*|(|o|)>>
      oder <math|x<around*|(|o<rprime|'>|)>=\<emptyset\>>. (Kein
      Informationsfluss aus Firma heraus, au�er wenn unkritisch, weil Objekt
      keine Konflikte hat.)
    </description>

    Vollst�ndig dynamisch
  </description>

  <subsection|Analyse gr��erer Systeme>

  <subsubsection|Security-Zugang>

  <\description>
    <item*|Motivation>Pr�fe gezielt Eigenschaften des Gesamtsystems, z.B. CIA
    (Confidentiality, Integrity, Availability)

    Konkrete Schutzziele aber anwendungsabh�ngig.

    Sicherheit gr��erer Systeme �berhaupt erst mit CIA-Paradigma
    beherrschbar.
  </description>

  <subsubsection|Kryptographischer Zugang>

  <\description>
    <item*|Motivation>Vergleiche reales System mit vereinfachtem, idealem
    System <math|\<rightarrow\>> reales System sicher, wenn \Rso sicher wie``
    Idealisierung. Ziel: genereller Sicherheitsbegriff.

    Ziel nicht durch Eigenschaften, sondern durch idealisiertes System
    vorgeben.

    <item*|Relation <math|\<geqslant\>> auf
    Protokollen><math|\<pi\><rsub|real>\<geqslant\>\<pi\><rsub|ideal>> hei�t
    <math|\<pi\><rsub|real>> mindestens so sicher wie
    <math|\<pi\><rsub|ideal>>.

    <math|\<pi\><rsub|1>> ist so sicher wie <math|\<pi\><rsub|2>>
    (<math|\<pi\><rsub|1>\<geqslant\>\<pi\><rsub|2>>), wenn f�r jeden
    effizienten Angreifer <math|\<cal-A\><rsub|1>> auf <math|\<pi\><rsub|1>>
    ein effizienter Angreifer <math|\<cal-A\><rsub|2>> auf
    <math|\<pi\><rsub|2>> existiert, so dass nicht effizient zwischen
    <math|<around*|(|\<pi\><rsub|1>,\<cal-A\><rsub|1>|)>> und
    <math|<around*|(|\<pi\><rsub|2>,\<cal-A\><rsub|2>|)>> unterschieden
    werden kann.

    <item*|Kompositionstheorem>Sei <math|\<pi\><rsup|\<tau\>>> ein Protokoll
    mit Unterprotokoll <math|\<tau\>>, und sei
    <math|\<rho\>\<geqslant\>\<tau\>>. Dann gilt
    <math|\<pi\><rsup|\<rho\>>\<geqslant\>\<pi\><rsup|\<tau\>>>. Zentral f�r
    modulare Analyse.

    <item*|Modulare Analyse>Formuliere gr��eres Protokoll
    <math|\<pi\><rsup|\<tau\>>> mit <em|idealisiertem> Baustein
    <math|\<tau\>> und beweise <math|\<pi\><rsup|\<tau\>>\<geqslant\>\<pi\><rprime|'>>
    (wobei <math|\<pi\><rprime|'>> = Protokollziel, z.B. sicheres
    Online-Banking). Ersetze dann idealisierte Bausteine durch reale
    Bausteine <math|\<rho\>> mit <math|\<rho\>\<geqslant\>\<tau\>>
    <math|\<Rightarrow\>> <math|\<pi\><rsup|\<rho\>>\<geqslant\>\<pi\><rsup|\<tau\>>\<geqslant\>\<pi\><rprime|'>>.

    Erlaubt getrennte Analyse von Teilsystemen
  </description>

  <subsection|H�ufige Sicherheitsl�cken>

  Ziel: Was kann bei <em|Implementierung> schiefgehen?

  <\description>
    <item*|Buffer Overflows>Wenn Benutzereingaben ohne �berpr�fung der
    Eingabel�nge verarbeitet werden, k�nnen Variablen/Speicherbereiche
    �berschrieben werden.

    z.B. R�cksprungadresse auf Stack ersetzen.

    Gegenma�nahmen: sichere Programmiersprachen, sichere Routinen, DEP, ALSR.

    <item*|Denial of Service>Verf�gbarkeit eines Systems durch viele Anfragen
    angreifen. Prinzipiell nur schwer verhinderbar

    Geschicktere Angriffe z.B. Hashtable-Kollisionen bei GET-Parametern

    <item*|Code Execution>Schlimm.

    <item*|Cross Site Scripting>Beispielsweise Einschleusen von JS-Code in
    Benutzereingaben, der bei anderem Benutzer ausgef�hrt wird. Hat z.B.
    Zugriff auf Cookies.

    <item*|SQL Injection>Mangelhafte �berpr�fung/Escaping von
    Benutzereingaben.

    <item*|Schlechte Zufallsgeneratoren>Mehrmals gleiches <math|e> f�r
    ElGamal-Signaturen verwenden, Debian-OpenSSL-Problem.

    <item*|Schlechte APIs>Unf�hige Programmierer, die APIs schnell lernen
    wollen; APIs, die bl�dsinnige Eingaben nicht verhindern.
  </description>
</body>

<\initial>
  <\collection>
    <associate|language|german>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-10|<tuple|7.3|?>>
    <associate|auto-11|<tuple|7.4|?>>
    <associate|auto-12|<tuple|8|?>>
    <associate|auto-13|<tuple|9|?>>
    <associate|auto-14|<tuple|10|?>>
    <associate|auto-15|<tuple|11|?>>
    <associate|auto-16|<tuple|12|?>>
    <associate|auto-17|<tuple|12.1|?>>
    <associate|auto-18|<tuple|12.2|?>>
    <associate|auto-19|<tuple|13|?>>
    <associate|auto-2|<tuple|2|?>>
    <associate|auto-3|<tuple|3|?>>
    <associate|auto-4|<tuple|4|?>>
    <associate|auto-5|<tuple|5|?>>
    <associate|auto-6|<tuple|6|?>>
    <associate|auto-7|<tuple|7|?>>
    <associate|auto-8|<tuple|7.1|?>>
    <associate|auto-9|<tuple|7.2|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <with|par-left|<quote|1.5fn>|Einf�hrung
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1>>

      <with|par-left|<quote|1.5fn>|Symmetrische Verschl�sselung
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>>

      <with|par-left|<quote|1.5fn>|Hashfunktionen
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|1.5fn>|Asymmetrische Verschl�sselung
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1.5fn>|Symmetrische Nachrichtenauthentifikation:
      MACs <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|1.5fn>|Asymmetrische Nachrichtenauthentifikation:
      Digitale Signaturen <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1.5fn>|Schl�sselaustauschprotokolle
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|3fn>|Symmetrische Verfahren
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|3fn>|Asymmetrische Verfahren
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|3fn>|TLS (Transport Layer Security)
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|3fn>|Weitere Schl�sselaustauschprotokolle
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|1.5fn>|Identifikationsprotokolle
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1.5fn>|Zero-Knowledge-Protokolle
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <with|par-left|<quote|1.5fn>|Benutzerauthentifikation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      <with|par-left|<quote|1.5fn>|Zugriffskontrolle
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <with|par-left|<quote|1.5fn>|Analyse gr��erer Systeme
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|3fn>|Security-Zugang
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <with|par-left|<quote|3fn>|Kryptographischer Zugang
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|1.5fn>|H�ufige Sicherheitsl�cken
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>
    </associate>
  </collection>
</auxiliary>