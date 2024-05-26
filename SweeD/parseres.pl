use strict;
# Input file: SweeD_Report.EGT, with chromosomes indicated by //1, for instance
print "\n**********************************************************";
print "\n*    parseres.pl                *";
print "\n*    Author: Kiwoong Nam                                *";
print "\n*    Date: 20240525        *";
print "\n*    CopyRight @ INRAe                    Licence GNU GPL  *";
print "\n**********************************************************";
print "\n Prepare SweeD report for plotting                      ";
print "\n**********************************************************\n";


# Définition du répertoire contenant les fichiers SweeD
my $Wdir = '/home/karine/Documents/Spodo/PROJET_slitto_2023_newref/SweeD/results/2024/';

# Appel de la fonction exet() pour le type d'analyse EGT
exet('EGT');

# Définition de la fonction exet() pour traiter le type d'analyse EGT
sub exet {
    my ($name) = @_;

    # Chemin vers les fichiers d'informations, de rapport et de sortie pour l'analyse EGT
    my $infoF   = "$Wdir/SweeD_Info.$name";
    my $reportF = "$Wdir/SweeD_Report.$name";
    my $output  = "$Wdir/SweeD_parsed.$name";

    my $chrN; # Numéro de chromosome en cours de traitement
    my %RES; # Hash pour stocker les résultats par chromosome

    # Ouverture du fichier de rapport et traitement des données
    open my $fd, $reportF or die "Impossible d'ouvrir le fichier $reportF : $!";
    while (<$fd>) {
        if (/\/\/(\d+)/) { # Recherche du numéro de chromosome à partir du marqueur //
            $chrN = $1; # Stockage du numéro de chromosome
        }
        elsif (/Position/) { next } # Ignorer la ligne d'en-tête
        elsif (/(\d+\.\d+)\s+(\S+)\s+(\S+)\s+(\d+\.\d+)\s+(\d+\.\d+)/) { # Extraction des données
            $RES{$chrN} .= "$chrN\t$1\t$2\t$3\t$4\t$5\n"; # Stockage des données dans le hash
        }
    }
    close $fd; # Fermeture du fichier de rapport

    my $res = "chrN\tpos\tlikelihood\talpha\tstartPos\tendPos\n"; # En-tête du fichier de sortie
    foreach my $chromosome (sort keys %RES) { # Parcours des numéros de chromosome
        $res .= $RES{$chromosome}; # Ajout des données pour chaque chromosome au résultat
    }

    # Ouverture du fichier de sortie en écriture
    open $fd, ">$output" or die "Impossible d'ouvrir le fichier $output en écriture : $!";
    print $fd $res; # Écriture du résultat dans le fichier de sortie
    close $fd; # Fermeture du fichier de sortie
}

