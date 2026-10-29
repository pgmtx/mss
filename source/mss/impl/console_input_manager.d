module mss.impl.console_input_manager;

import mss.core.component : InputManager;
import mss.core.matrix;
import std.stdio : readfln, write, writeln;

class ConsoleInputManager : InputManager
{
    string readLine(string prompt)
    {
        write(prompt);
        string result;
        readfln("%s", result);
        return result;
    }

    int readInt(string prompt, int min, int max)
    {
        int result;
        while (true)
        {
            write(prompt);
            readfln("%d", result);
            if (min <= result && result <= max)
            {
                break;
            }
            writeln("Please enter a value between ", min, " and ", max);
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
        }
        catch (FileException _)
        {
            throw new UnreadableFileException("could not read the file " ~ path);
        }
        catch (CSVException _)
        {
            throw new UnreadableFileException("could not parse the file " ~ path);
        }
        return Matrix.of(values);
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
        return Matrix.of([[0, 0], [0, 0]]);
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
