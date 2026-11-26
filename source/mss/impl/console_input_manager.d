module mss.impl.console_input_manager;

import mss.core.component : InputManager;
import mss.core.matrix;
import std.stdio : readfln, write, writeln;

class ConsoleInputManager : InputManager
{
    string readLine(const string prompt)
    {
        write(prompt);
        string result;
        readfln("%s", result);
        return result;
    }

    int readInt(const string prompt, int min, int max)
    {
        import std.conv : ConvException;

        int result;
        while (true)
        {
            write(prompt);
            try
            {
                readfln("%d", &result);
            }
            // si l'entrée n'est pas un nombre
            catch (ConvException)
            {
                result = max + 1;
            }

            if (min <= result && result <= max)
            {
                break;
            }
            writeln("Veuillez entrer une valeur entre ", min, " et ", max);
        }
        return result;
    }

    Matrix readCsv(const string path)
    {
        import mss.core.error : UnreadableFileException;
        import std.algorithm : map;
        import std.array : array;
        import std.csv : CSVException, csvReader;
        import std.file : FileException, readText;

        long[][] values;
        try
        {
            immutable content = readText(path);
            values = csvReader!long(content).map!(r => r.array).array;
            foreach (row; values)
            {
                foreach (value; row)
                {
                    MatrixRules.checkValue(value);
                }
            }
        }
        catch (FileException)
        {
            throw new UnreadableFileException("impossible de lire le fichier " ~ path);
        }
        catch (CSVException)
        {
            throw new UnreadableFileException("impossible d'analyser le fichier " ~ path);
        }

        auto result = Matrix.of(values);
        return result;
    }

    Matrix enterMatrix(MatrixSize size)
    {
        import std.format : format;

        auto values = new long[][](size, size);
        foreach (i, ref row; values)
        {
            foreach (j, ref value; row)
            {
                immutable prompt = format("M(%d,%d) = ", i + 1, j + 1);
                value = readInt(prompt, MatrixRules.minValue, MatrixRules.maxValue);
            }
        }
        return Matrix.of(values);
    }

    Matrix generateRandom(MatrixSize size)
    {
        import std.random : uniform;

        auto values = new long[][](size, size);
        foreach (i, ref row; values)
        {
            foreach (j, ref value; row)
            {
                value = uniform(MatrixRules.minValue, MatrixRules.maxValue + 1);
            }
        }
        return Matrix.of(values);
    }

    Matrix acquire(const InputMatrix input)
    {
        return input.getMatrix();
    }
}
