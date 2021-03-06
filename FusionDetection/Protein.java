import java.util.List;

/**
 * Created by students on 26.04.17.
 */
public class Protein {
    String name;
    String seq;
    int length;

    public Protein(String name){
        this.name = name;
    }

    public Protein(String name, String seq){
        this.name = name;
        this.seq = seq;
        this.length = seq.length();
    }

    public String getName() {
        return name;
    }

    public boolean containedIn(List<Protein> proteinList){
        for (Protein protein : proteinList) {
            if(protein.getName() == name){
                return true;
            }
        }
        return false;
    }

    public int getLength() {
        try {
            Integer.valueOf(length);
        }
        catch (NumberFormatException ex){
            System.err.println("LENGTH OF " + name + " IS NULL!");
        }
        return length;
    }

    public void removeSeq(){
        seq = null;
    }

    public String getSeq() {
        return seq;
    }

    public String getProteinAsFasta(){
        String parsedStr = seq.replaceAll("(.{80})", "$1\n");
        String fastaProtein = ">" + name + "\n" + parsedStr;
        return fastaProtein;
    }
}
