<TeXmacs|1.0.7.10>

<style|generic>

<\body>
  <doc-data|<doc-title|Sicherheit>>

  <subsection|Einführung>

  <\description>
    <item*|Kerckhoffs' Prinzip>Sicherheit des Verschlüsselungsverfahrens
    beruht auf der Geheimhaltung des Schlüssels, nicht des Verfahrens
  </description>

  <subsection|Symmetrische Verschlüsselung>

  <\description>
    <item*|Symmetrische Verschlüsselung>Alice und Bob haben gemeinsames
    Geheimnis <math|K>

    Chiffrat <math|C\<assign\>Enc<around*|(|K,M|)>>, Nachricht
    <math|M\<assign\>Dec<around*|(|K,C|)>>

    <item*|Cäsar-Verfahren>Verschiebe Buchstaben um <math|K>

    <item*|Vigenère-Verfahren>Schlüssel <math|K\<in\><around*|{|0,\<ldots\>,25|}><rsup|m>>,
    <math|m> Schlüssellänge

    <math|\<Rightarrow\>> aber: Periodische Wiederverwendung des Schlüssels

    <item*|One-Time-Pad (OTP)>Schlüssel so lang wie Nachricht.
    <math|Enc<around*|(|K,M|)>=M\<oplus\>K>,
    <math|Dec<around*|(|K,C|)>=C\<oplus\>K>, wobei der Schlüssel
    gleichverteilt gezogen ist.

    Nachteil 1) Schlüssel darf nicht wiederverwendet werden (sonst
    <math|C\<oplus\>C<rprime|'>=M\<oplus\>M<rprime|'>>)

    Nachteil 2) Chiffrat verwundbar <math|C\<oplus\>X=<around*|(|M\<oplus\>X|)>\<oplus\>K>

    Nachteil 3) unhandlich

    <item*|Stromchiffren>Ersetze unhandliches OTP durch OTP-\RSimulation``
    mit kurzem Schlüssel <math|K>. Generiere daraus
    <math|K<rprime|'>\<assign\>G<around*|(|K|)>\<in\><around*|{|0,1|}><rsup|n>>
    und verwende <math|K<rprime|'>> für OTP.

    Ziel: Pseudozufall <math|G<around*|(|K|)>> soll aussehen wie echter
    Zufall

    <\description>
      <item*|Struktur von Stromchiffren>Interner Zustand
      <math|K\<in\><around*|{|0,1|}><rsup|k>>, Anfangszustand <math|K>. Jeder
      Schritt erzeugt ein Bit als Ausgabe:
      <math|SC<around*|(|K|)>\<assign\><around*|(|b,K<rprime|'>|)>> mit
      <math|K<rprime|'>\<in\><around*|{|0,1|}><rsup|k>>. Bitfolge
      <math|b<rsub|i>> ist der Schlüssel <math|G<around*|(|K|)>>.

      <item*|Schieberegister (LSFR, Linear Feedback Shift Register)>VL02,
      Seite 6. Ausgabe <math|b\<assign\>K<rsub|1>> (erstes Bit von <math|K>),
      neues Zustandsbit <math|z\<assign\><big-around|\<sum\>|<rsub|i=1><rsup|n>\<alpha\><rsub|i>K<rsub|i>>
      mod 2>.

      UNSICHER, selbst wenn <math|\<alpha\><rsub|i>> geheim.

      <item*|Eigenschaften>Schnell (vor allem in Hardware), ein oder mehrere
      LSFRs.

      Algebraische Angriffe möglich, wg. Schlüsselupdate Synchronisation
      nötig (TODO: ?), wie bei OTP Chiffrate verwundbar.
    </description>

    <item*|Blockchiffren>Zentraler Baustein Funktion
    <math|E:<around*|{|0,1|}><rsup|k>\<times\><around*|{|0,1|}><rsup|\<ell\>>\<rightarrow\><around*|{|0,1|}><rsup|\<ell\>>>
    (Schlüssel + Klartextblock <math|\<rightarrow\>> Chiffratblock). <math|E>
    + verschiedene <em|Betriebsmodi> <math|\<rightarrow\>> <math|Enc>

    <\description>
      <item*|Electronic Codebook Mode (ECB)>Teile <math|M> in
      <math|\<ell\>>-Bit-Blöcke auf und verschlüssele jeden Block mit
      demselben Schlüssel <math|K>.

      <math|+> einfach, kein Zustandsupdate nötig, keine Synchronisation
      nötig

      -- Gleiche Nachricht <math|\<Rightarrow\>> gleiches Chiffrat,
      Umsortieren/Einfügen von Chiffratblöcken möglich

      <item*|Cipher Block Chaining Mode (CBC)>Behebt Nachteile des ECB: Setze
      <math|C<rsub|0>\<assign\>IV> (Initialisierungsvektor), setze
      <math|C<rsub|i>\<assign\>E<around*|(|K,M<rsub|i>\<oplus\>C<rsub|i-1>|)>>.

      Initialisierungsvektor muss nicht geheim sein (darf aber nicht
      veränderbar sein)!

      Visualisierung siehe <hlink|http://de.wikipedia.org/wiki/Cipher_Block_Chaining_Mode|http://de.wikipedia.org/wiki/Cipher_Block_Chaining_Mode>

      Entschlüsselung: <math|M<rsub|i>\<assign\>D<around*|(|K,C<rsub|i>|)>\<oplus\>C<rsub|i-1>>

      + Gleiche Nachricht <math|\<Rightarrow\>> unterschiedliche Chiffrate,
      Umsortieren führt zu fehlerhaften Blöcken (Fehler im Geheimtextblock
      führt zu Fehler bei diesem und nächstem Block)

      -- Synchronisation nötig (da vorheriges Chiffrat bekannt sein muss

      <item*|Cipher Feedback Mode (CFB)><math|C<rsub|i>\<assign\>E<around*|(|K,C<rsub|i-1>|)>\<oplus\>M<rsub|i>>
      (ähnlich Stromchiffre)

      <item*|Output Feedback Mode (OFB)><math|C<rsub|i>\<assign\><wide*|E<around*|(|K,D<rsub|i-1>|)>|\<wide-underbrace\>><rsub|D<rsub|i>>\<oplus\>M<rsub|i>>
      (ist letztlich Stromch.)

      <item*|Data Encryption Standard (DES)><math|E> mit
      <math|k=56,\<ell\>=64>. Mittlerweile veraltet, da zu kurzer Schlüssel

      Rundenfunktion <math|F:<around*|{|0,1|}><rsup|48>\<times\><around*|{|0,1|}><rsup|32>\<rightarrow\><around*|{|0,1|}><rsup|32>>;
      Feistelstruktur (TODO)

      <item*|2DES>Naive Verbesserung (zwei Schlüssel);
      Meet-in-the-Middle-Angriff möglich

      <item*|3DES>Drei Schlüssel, 3x DES anwenden <math|\<Rightarrow\>>
      sicherer

      <item*|Advanced Encryption Standard (AES)><math|E> mit
      <math|k\<in\><around*|{|128,192,256|}>>, <math|\<ell\>=128>, keine
      Feistelstruktur, nach heutigem Kenntnisstand sicher
    </description>

    <item*|Angriffe auf Blockchiffren>

    <\description>
      <item*|Lineare Kryptoanalyse>Finde <math|\<bbb-F\><rsub|2>>-lineare
      Abhängigkeiten zwischen den Bits von <math|X> und
      <math|E<around*|(|K,X|)>>. Bei Feistel-Verfahren mit <math|n> Runden
      indirekter Angriff möglich (TODO)

      <item*|Differentielle Kryptoanalyse>Betrachte Ausgabedifferenzen in
      Abhängigkeit von Eingabedifferenzen (dabei fällt Rundenschlüssel weg)
    </description>

    <item*|Formalisierung von Sicherheit>Nur passive Angriffe betrachtet.

    <\description>
      <item*|Semantische Sicherheit>Chiffrat verrät nur die Länge der
      Nachricht. (Jede Information, die aus dem Chiffrat abgeleitet werden
      kann, kann aus einer beliebigen Nachricht gleicher Länge abgeleitet
      werden)

      Existenz von (mehrfach benutzbaren) semantisch sicheren Verfahren
      <math|\<Rightarrow\> P\<neq\>N P>.

      <item*|IND-CPA (Indistinguisability under chosen-plaintext
      attacks)>Kein effizienter Angreifer <math|\<cal-A\>> kann Chiffrate
      selbstgewählter Klartexte unterscheiden.

      Spiel: <math|\<cal-A\>> hat Zugriff auf
      <math|Enc<around*|(|K,\<cdummy\>|)>>-Orakel. Wählt zwei Nachrichten
      <math|M<rsub|1>>, <math|M<rsub|2>> gleicher Länge, bekommt das Chiffrat
      einer der beiden Nachrichten und muss raten, zu welcher der Nachrichten
      es gehört.

      Schema IND-CPA-sicher, wenn für alle Angreifer die
      Gewinnwahrscheinlichkeit nahe bei <math|1/2> liegt.

      IND-CPA äquivalent zur semantischen Sicherheit.

      <\description>
        <item*|ECB-Mode>Nicht semantisch sicher, da gleiche Nachricht
        <math|\<Rightarrow\>> gleiches Chiffrat. <math|\<cal-A\>> kann also
        die Chiffrate im Voraus berechnen und gewinnt immer.

        <item*|CBC>IND-CPA-sicher, wenn <math|E<around*|(|K,\<cdummy\>|)>>
        für zufälliges <math|K> ununterscheidbar von einer Zufallsfunktion
        <math|R> ist.

        Beweis: Baue aus IND-CPA-Angreifer einen <math|E/R>-Unterscheider

        <item*|Stromchiffren>Zustandsbehaftete Stromchiffre IND-CPA-sicher,
        wenn verwendetes <math|SC<around*|(|K|)>> für zufälliges <math|K>
        ununterscheidbar von zufälligem <math|U>.

        <item*|Feistel-Schema>Wenn <math|F<around*|(|K,\<cdummy\>|)>> mit
        zufälligem <math|K> ununterscheidbar von einer zufälligen Funktion,
        dann ist <math|Enc<around*|(|K,\<cdummy\>|)>> ununterscheidbar von
        einer zufälligen invertierbaren Funktion.
      </description>
    </description>
  </description>

  <subsection|Hashfunktionen>

  <\description>
    <item*|Definition><math|H<rsub|k> : <around*|{|0,1|}><rsup|\<ast\>>\<rightarrow\><around*|{|0,1|}><rsup|k>>,
    kurzer \RFingerabdruck`` groÿer Daten

    <item*|Kollisionsresistenz>Jeder PPT-Algorithmus findet nur mit höchstens
    vernachlässigbarer Wahrscheinlichkeit eine Kollision.

    <\description>
      <item*|PPT (Probabilistic Polynomial Time)>Algorithmus läuft in
      Polynomialzeit und gibt \RJa`` mit Wahrscheinlichkeit
      <math|\<gtr\><frac|1|2>> aus gdw. Antwort \RJa`` lautet.

      <item*|Vernachlässigbare Funktion><math|<around*|\||f|\|>> verschwindet
      asymptotisch schneller als der Kehrwert eines beliebigen Polynoms.
    </description>

    <item*|Einwegeigenschaft (bei Hashfunktionen: Preimage Resistance)>Eine
    Funktion <math|H<rsub|k>> ist eine Einwegfunktion bezüglich der
    Urbildverteilung <math|\<cal-X\><rsub|k>>, wenn jeder PPT-Algorithmus nur
    mit höchstens vernachlässigbarer Wahrscheinlichkeit <em|ein> Urbild eines
    gegebenen, aus <math|\<cal-X\><rsub|k>> gezogenen Bildes findet.

    Folgt aus Kollisionsresistenz: Zu jedem <math|H>-Invertierer kann ein
    Kollisionsfinder angegeben werden (TODO)

    <item*|Target Collision Resistance>Gegeben <math|X>, finde
    <math|X<rprime|'>> mit <math|H<around*|(|X|)>=H<around*|(|X<rprime|'>|)>>.
    Wird impliziert von Kollisionsresistenz und impliziert Einwegeigenschaft

    <item*|Merkle-Damgård-Konstruktion>Baue Hashfunktion aus einfacherem
    Baustein: Kompressionsfunktion <math|F:<around*|{|0,1|}><rsup|2k>\<rightarrow\><around*|{|0,1|}><rsup|k>>.
    Wiederholte Anwendung von <math|F> auf Nachrichtenblöcke, zu Anfang mit
    einem Initialisierungsvektor

    <math|F> kollisionsresistent <math|\<Rightarrow\>> <math|H<rsub|MD>>
    kollisionsresistent

    <item*|Beispiele>MD5 (Ausgabe 128 Bits, gebrochen), SHA-1 (Ausgabe 160
    Bits, gebrochen), SHA-3 (Ausgabelänge variabel)

    <item*|Birthday Attack>Betrachte viele <math|H<around*|(|X<rsub|i>|)>>
    für zufällige <math|X<rsub|i>>. Für <math|2<rsup|k/2>> verschiedene
    <math|X<rsub|i>> gibt es Kollision unter den
    <math|H<around*|(|X<rsub|i>|)>> mit Wahrscheinlichkeit
    <math|p\<gtr\><frac|1|11>>.

    <item*|Lehre>Ausgabelänge <math|\<geqslant\>> <math|k> Bits für
    <math|k/2> Bits \RSicherheit``
  </description>

  <subsection|Asymmetrische Verschlüsselung>

  <\description>
    <item*|Idee>Bei symmetrischer Verschlüsselung viele Schlüssel nötig:
    <math|<matrix|<tformat|<table|<row|<cell|n>>|<row|<cell|2>>>>>> für
    <math|n> Benutzer. Schlüsselverteilung ist auch schwierig.

    Grundidee: Öffentlicher Schlüssel <em|pk>, geheimer Schlüssel <em|sk>,
    gemeinsam generiert: <math|<around*|(|pk,sk|)>\<leftarrow\>Gen<around*|(|1<rsup|k>|)>>.
    <math|C\<assign\>Enc<around*|(|pk,M|)>>; <math|M=Dec<around*|(|sk,C|)>>.

    <item*|RSA>(Rivest/Shamir/Adleman) <math|pk=<around*|(|N,e|)>\<nocomma\>>,
    <math|sk=<around*|(|N,d|)>>, wobei <math|N=P*Q> für groÿe Primzahlen
    <math|P\<neq\>Q> und <math|e\<cdot\>d=1 mod
    <around*|(|\<varphi\><around*|(|N|)>=<around*|(|P-1|)><around*|(|Q-1|)>|)>>.
    Nachrichtenraum <math|\<bbb-Z\><rsub|N>>

    <math|Enc<around*|(|pk,M|)>=M<rsup|e>> mod <math|N>,
    <math|Dec<around*|(|sk,C|)>=C<rsup|d>> mod <math|N>

    <\description>
      <item*|Schlüsselgenerierung>Wähle <math|P,Q> zufällig; wähle <math|e>
      zufällig solange, bis invertierbar modulo
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

      <item*|Sicherheit>RSA ist nicht semantisch sicher, da RSA
      deterministisch: Information <math|f<around*|(|M|)>=M<rsup|e> mod N>
      mit Chiffrat berechenbar. (Alternativ: Angreifer kann Nachrichten im
      Sicherheitsspiel unterscheiden.)

      <item*|Weitere Angriffe><math|e=3> für alle Benutzer problematisch,
      wenn <math|M> an <math|\<geqslant\> 3> Benutzer gesendet wird. Gleiches
      <math|N> für alle Benutzer ist auch problematisch.

      <item*|Homomorphie><math|Enc<around*|(|pk,M|)>\<cdot\>Enc<around*|(|pk,M<rprime|'>|)>=Enc<around*|(|pk,M\<cdot\>M<rprime|'>|)>>.

      <item*|Reparatur: RSA-OAEP>Padding; allerdings rechenaufwändig.
    </description>

    <item*|ElGamal>Zyklische Gruppe <math|\<bbb-G\>=<around*|\<langle\>|g|\<rangle\>>>.
    <math|pk=<around*|(|\<bbb-G\>,g,g<rsup|x>|)>>,
    <math|sk=<around*|(|\<bbb-G\>,g,x|)>> mit zufälligem <math|x>.

    <math|Enc<around*|(|pk,M|)>=<around*|(|g<rsup|y>,g<rsup|x*y>\<cdot\>M|)>>
    mit zufälligem <math|y>; <math|Dec<around*|(|sk,<around*|(|X,Z|)>|)>=Z/Y<rsup|x>>

    Homomorph wie RSA (nicht-homomorphe Varianten existieren).

    Geeignete Gruppen <math|\<bbb-G\>:> Echte Untergruppen von
    <math|\<bbb-Z\><rsub|P><rsup|\<ast\>>> mit <math|P> prim, Untergruppen
    von <math|\<bbb-F\><rsub|q><rsup|*\<ast\>>> mit <math|q> Primpotenz,
    Untergruppen von elliptischer Kurve <math|E<around*|(|\<bbb-F\><rsub|q>|)>>

    <\description>
      <item*|Sicherheit>Unter naheliegender Annahme semantisch sicher.
    </description>

    <item*|Semantische Sicherheit für PK-Verfahren>wie für symetrische
    Verfahren, äquivalent zu IND-CPA
  </description>

  <subsection|Symmetrische Nachrichtenauthentifikation: MACs>

  <\description>
    <item*|Ziel>Authentifizierte Übermittlung auf unauthentifiziertem Kanal:
    Schütze Nachricht vor Veränderungen, indem \RUnterschrift``
    <math|\<sigma\>> mit Nachricht gesendet wird.

    <item*|Message Authentication Code (MAC)>Gemeinsames Geheimnis <math|K>;
    <math|\<sigma\>\<leftarrow\>Sig<around*|(|K,M|)>>, Verifizieren
    <math|Ver<around*|(|K,M,\<sigma\>|)>\<in\><around*|{|0,1|}>>.

    Korrektheit <math|Ver<around*|(|K,M,\<sigma\>|)>=1> für alle
    <math|K,M,\<sigma\>\<leftarrow\>Sig<around*|(|K,M|)>>.

    <item*|EUF-CMA-Sicherheit (Existential unforgability under chosen message
    attack)>Spiel: <verbatim|<math|\<cal-A\>>> hat Zugriff auf
    <math|Sig<around*|(|K,\<cdummy\>|)>>-Orakel; gewinnt, wenn er neue(!)
    Nachricht <math|M> mit gültiger Signatur erzeugen kann.

    Passiver Angriff; <math|\<cal-A\>> erhält keinen Zugriff auf <math|Ver>.
    Ist aber bei vielen Verfahren (z.B. eindeutiges <math|\<sigma\>>)
    äquivalent zu Definition mit <math|Ver>-Orakel für <math|\<cal-A\>>.

    <item*|Hash-Then-Sign>Signiere <math|H<around*|(|M|)>> statt <math|M>.
    Ist EUF-CMA-sicher, wenn das zugrundeliegende Signaturverfahren
    EUF-CMA-sicher ist und <math|H> kollisionsresistent.

    <item*|Pseudorandom Functions>Ununterscheidbar von echtem Zufall.
    Beispiel <math|PRF<around*|(|K,X|)>=H<around*|(|K,X|)>>. Aber z.B. bei
    MD-Konstruktion wird PRF-Eigenschaft gebrochen für Nachrichten
    unterschiedlicher Länge (Hashwert kann \Rerweitert`` werden).

    <item*|PRF und Hashfunktion <math|\<rightarrow\>>
    MAC><math|Sig<around*|(|K,M|)>=PRF<around*|(|K,H<around*|(|M|)>|)>> für
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
    <item*|Motivation>Wie bei symmetrischer Verschlüsselung: viele Schlüssel,
    Verteilungsproblem

    <item*|Public/Secret key><math|<around*|(|pk,sk|)>\<leftarrow\>Gen<around*|(|1<rsup|k>|)>>.
    <math|\<sigma\>\<leftarrow\>Sig<around*|(|sk,M|)>>,
    <math|Ver<around*|(|pk,M,\<sigma\>|)>\<in\><around*|{|0,1|}>>.
    Korrektheit wie bei MAC.

    <item*|EUF-CMA>Wie oben, Angreifer hat Zugriff auf
    <math|Sig<around*|(|sk,\<cdummy\>|)>>-Orakel.

    <item*|RSA-Signaturen>Verschlüsselung:
    <math|Enc<around*|(|pk,M|)>=M<rsup|e> mod N>.
    <math|Dec<around*|(|sk,C|)>=C<rsup|d> mod N>

    NEU Signatur: <math|Sig<around*|(|sk,M|)>=M<rsup|d> mod N>;
    <math|Ver<around*|(|pk,M,\<sigma\>|)>=1 :\<Leftrightarrow\>
    M=\<sigma\><rsup|e> mod N>.

    (Funktioniert nicht unbedingt für alle Verschlüsselungsschemata:
    Datentypproblem, <math|Enc> muss nicht deterministisch sein)

    <\description>
      <item*|Probleme>Zu (unsinniger) Signatur kann Nachricht erzeugt werden:
      <math|M\<assign\>\<sigma\><rsup|e> mod N>. Bricht EUF-CMA-Sicherheit.
      Auch Homomorphie ist ein Problem (bricht ebenfalls EUF-CMA-Sicherheit).

      <item*|Lösung: RSA-PSS (Probabilistic Signature Scheme)>Padding
      mithilfe von Hashfunktion <math|H> und MGF.

      <math|Sig<around*|(|sk,M|)>=<around*|(|pad<around*|(|M|)>|)><rsup|d>
      mod N>. <math|Ver<around*|(|pk,M,\<sigma\>|)>=1 :\<Leftrightarrow\>
      \<sigma\><rsup|e> mod N> ist gültiges <math|pad<around*|(|M|)>>.

      Mit idealem <math|H>, MGF EUF-CMA-sicher, wenn RSA-Funktion schwer zu
      invertieren.
    </description>

    <item*|ElGamal-Signaturen><math|pk=<around*|(|\<bbb-G\>,g,g<rsup|x>|)>>,
    <math|sk=<around*|(|\<bbb-G\>,g,x|)>> wie bei ElGamal-Verschlüsselung

    Setze <math|a\<assign\>g<rsup|e>> für zufälliges <math|e>; <math|b> als
    Lösung von <math|a*x+e*b=M mod <around*|\||\<bbb-G\>|\|>>

    <math|Sig<around*|(|sk,M|)>=<around*|(|a,b|)>>,
    <math|Ver<around*|(|pk,M,\<sigma\>|)>=1
    :\<Leftrightarrow\><around*|(|g<rsup|x>|)><rsup|a>a<rsup|b>=g<rsup|M>>.
    Dabei <math|a=g<rsup|e>> sowohl als <math|\<bbb-G\>>-Element als auch als
    Expontent verwendet.

    Es darf für verschiedene <math|M> nie dasselbe <math|e> verwendet werden.

    Wie RSA nicht EUF-CMA-sicher (TODO VL07, S. 25)

    <item*|Hash-then-sign>Wie bei MACs, auch EUF-CMA-Sicherheit.

    <item*|DSA (Digital Signature Algorithm)>Wie ElGamal, aber nicht
    <math|a*x+e*b=M mod <around*|\||\<bbb-G\>|\|>>, sondern
    <math|a*x+e*b=H<around*|(|M|)> mod <around*|\||\<bbb-G\>|\|>>.
    EUF-CMA-Sicherheit gegenwärtig unklar.
  </description>

  <subsection|Schlüsselaustauschprotokolle>

  <subsection|Identifikationsprotokolle>

  <subsection|Zero-Knowledge-Protokolle>

  <subsection|Benutzerauthentifikation>

  <subsection|Zugriffskontrolle>

  <subsection|Analyse gröÿerer Systeme>

  <subsection|Häufige Sicherheitslücken>
</body>

<\initial>
  <\collection>
    <associate|language|german>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-10|<tuple|10|?>>
    <associate|auto-11|<tuple|11|?>>
    <associate|auto-12|<tuple|12|?>>
    <associate|auto-13|<tuple|13|?>>
    <associate|auto-2|<tuple|2|?>>
    <associate|auto-3|<tuple|3|?>>
    <associate|auto-4|<tuple|4|?>>
    <associate|auto-5|<tuple|5|?>>
    <associate|auto-6|<tuple|6|?>>
    <associate|auto-7|<tuple|7|?>>
    <associate|auto-8|<tuple|8|?>>
    <associate|auto-9|<tuple|9|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <with|par-left|<quote|1.5fn>|Einführung
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1>>

      <with|par-left|<quote|1.5fn>|Symmetrische Verschlüsselung
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>>

      <with|par-left|<quote|1.5fn>|Hashfunktionen
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|1.5fn>|Asymmetrische Verschlüsselung
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1.5fn>|Symmetrische Nachrichtenauthentifikation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|1.5fn>|Asymmetrische Nachrichtenauthentifikation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1.5fn>|Schlüsselaustauschprotokolle
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|1.5fn>|Identifikationsprotokolle
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1.5fn>|Zero-Knowledge-Protokolle
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1.5fn>|Benutzerauthentifikation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|1.5fn>|Zugriffskontrolle
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|1.5fn>|Analyse gröÿerer Systeme
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1.5fn>|Häufige Sicherheitslücken
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>
    </associate>
  </collection>
</auxiliary>