# 24-hour Alarm Clock

V tomto projektu se budeme zabývat vytvořením funkčních digitálních 24hodinových hodin s integrovanou funkcí alarmu, implementované na vývojové desce Nexys A7-50T.
Systém udržuje přesný čas pomocí kaskády čítačů a umožňuje uživateli nastavit čas buzení. Aktuální čas a nastavený alarm jsou zobrazeny současně na osmi pozicích sedmisegmentového displeje díky technice časového multiplexingu.

## Členové týmu a kompetence
* Martin Doucha
* Jan Kocourek
* Pavel Čurda

## Blokové schéma
<img width="1851" height="772" alt="schema_final drawio" src="schema_final.drawio.png" />



## Vstupy
Ovládání systému je realizováno pomocí tlačítek na desce Nexys:
* **BTNC**: Hlavní reset celého systému.
* **BTNL**: Tlačítko vypnutí alarmu.
* Další tlačítka budou využita pro nastavení hodnot času a alarmu.

## Výstupy
Výstupní data jsou zobrazena na následujících periferiích:

### Sedmisegmentový displej
* **DISP 0 až 3**: Zobrazení aktuálního času (hodiny a minuty).
* **DISP 4 až 7**: Zobrazení času nastaveného alarmu.

### Dvojtečka (DP)
* Slouží k vizuálnímu oddělení hodin a minut nebo indikaci vteřinového taktu.

## Komponenty
### Snooze
Hlavní řídící logický blok pro zapínání a vypínání budíku alarmu.

<img width="901" height="316" alt="Obrázek simulace Snooze bloku a jeho reakci na spuštění a samostatného vypnutí po uplynutí času." src="simulace/SnoozeTBonTimeout.png" />

<img width="1409" height="306" alt="Obrázek simulace Snooze bloku a jeho reakci na spuštění a odložení alarmu tlačítkem." src="simulace/SnoozeTBonPress.png" />

### rising_edge_detector
Pomocná součástka která vytvoří jedni clockový puls při detekci náběžné hrany.

<img width="1037" height="215" alt="Obrázek simulace rising_edge_detector bloku a jeho reakci na náběžnou hranu vstupního signálu." src="simulace/rising_edge_detectorTB.png" />

### debounce
Upravená součástka z počítačových cvičení, s detekcí držení.

<img width="1313" height="302" alt="Obrázek simulace debounce bloku, s dalšími výstupními signály." src="simulace/debounceTB.png" />

### countery_cas = aktuální čas
Tato součástka má dva režimy, které se dají přepínat switch2. Když je hodnota switche2 0 čas je měřen (pomocí pulzu na clk_en) a komponenta funguje jako hodiny. Pokud je switch2 na hodnotě 1, je možno nastavovat čas pomocí tlačítka a switche jako u counter_set_time.
Switch 2 je na 0, to znamená že čas samovolně běží:
<img width="1313" height="352" alt="Obrázek simulace bloku countery_cas" src="simulace/counter_time_cas_bezi.png" />
Switch 2 je na 1 a switch na 1 ,to znamená, že je možno tlačítkem přenastavovat hodiny
<img width="1313" height="352" alt="Obrázek simulace bloku countery_cas" src="simulace/counter_time_nastaveni_minut.png" />
Switch 2 je na 1 a switch na 0 ,to znamená, že je možno tlačítkem přenastavovat hodiny
<img width="1313" height="352" alt="Obrázek simulace bloku countery_cas" src="simulace/counter_time_nastaveni_hodin.png" />

### counter_time
Součástka složená z kombinace součástek countery_cas a clk_en. Protože pro určení jedné minuty s frekvencí 100 MHz by G_MAX bylo příliš velké číslo, je zde zaveden komponent clk_en s hodnotou G_MAX = 100_000_000, který generuje puls každou sekundu. Tyto pulsy jsou pak počítány counterem v procesu p_minute_maker, který sčítá sekundové pulsy a každou minutu vygeneruje puls sig_one_mini, který je přiveden na en vstup součástky countery_cas.

Simulace přechodů minut (cnt2mj a cnt2md):
<img width="1313" height="352" alt="Obrázek simulace bloku countery_cas" src="simulace/simulace_counter_time_prechody_minut.png" />

Simulace přechodů hodin (cnt2hj a cnt2hd):
<img width="1313" height="352" alt="Obrázek simulace bloku countery_cas" src="simulace/simulace_counter_time_prechody_hodin.png" />

Simulace překlopení z 23:59 na 0:00 :
<img width="1313" height="352" alt="Obrázek simulace bloku countery_cas" src="simulace/simulace_counter_time_reset.png" />

### counter_set_time = budík
Upravený blok counterů pro nastavování času budíku. Pomocí switche je možno přepínat mezi nastavováním minut a hodin.
Simulace nastavování hodin (poloha switche 0):
<img width="1313" height="352" alt="Obrázek simulace bloku countery_set_time_hodiny" src="simulace/simulace_counter_set_time_hours.png" />
Simulace nastavování minut (poloha switche 1):
<img width="1313" height="352" alt="Obrázek simulace bloku countery_set_time_hodiny" src="simulace/simulace_counter_set_time_minutes.png" />

